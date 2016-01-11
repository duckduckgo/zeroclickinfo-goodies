package DDG::Goodie::Dice;
# ABSTRACT: roll a number of (abstract) dice.
# https://en.wikipedia.org/wiki/Dice_notation

use strict;
use DDG::Goodie;

triggers start => "roll", "throw";

zci answer_type => "dice_roll";
zci is_cached => 0;

# roll_dice generate pseudo random roll
# param $_[0] number of faces
# return roll
sub roll_die {
    return int(rand($_[0])) + 1 if $_;
}

# set_num_dice set the number of dice to be rolled
# param user input x, ex. 'xd4' or 'x dice'
# param default for no label, ex. 'd20' or 'dice'
# return the number of dice to be rolled
sub set_num_dice {
    my $num_dice = $_[0];
    my $num_dice_default = $_[1];
    if(defined($num_dice)){
        if ($num_dice ne ''){
            return $num_dice;
        }else{
            return $num_dice_default;
        }
    }else{
        return 1;
    }
}

# shorthand_roll_output generate shorthand roll output
# param array of rolls
# param sum of rolls
# return roll output
sub plaintext_output {
    my $data = shift;
    my $out;
    my @rolls = @{$data->{'rolls'}};
    if (scalar @rolls > 1) {
        $out = join(' + ', @rolls); # append current roll to output
        if ($data->{'modifier'}) {
            $out .= ' ('.$data->{'modifier'}.')';
        }
        $out .= " = ".$data->{'total'}; # append sum of rolls to output
     } else {
         $out = $data->{'total'}; # output is roll value if we have just one roll
   }
   return $out;
}

handle remainder_lc => sub {
    # Ensure rand is seeded for each process
    srand();

    my @values = split(' and ', $_);
    my $values = @values; # size of @values;

    my $total; # total of all dice rolls
    my @all_rolls; # each of each homogeneous rolls

    foreach (@values) {
        if ($_ =~ /^(?:a? ?die|(\d{0,2})\s*dic?e)$/) {
            # ex. 'a die', '2 dice', '5dice'
            my @rolls;
            my $sum = 0;
            my $number_of_dice = set_num_dice($1, 2); # set number of dice, default 2
            
            if( $number_of_dice == 0) {
                return; # do not continue if conditions not met
            }

            for (1 .. $number_of_dice) { # for each dice
                my $roll = roll_die(6); # roll the die
                $sum += $roll; # track sum
                push @rolls, $roll
            }
            
            $total += $sum; # track total of all rolls
            push @all_rolls, { rolls => \@rolls, total => $sum, standard => 1, faces => 6, multiple => scalar @rolls > 1 };
        }
        elsif ($_ =~ /^(\d*)[d|w](\d+)\s?([+-])?\s?(\d+|[lh])?$/) {
            # ex. '2d8', '2w6 - l', '3d4 + 4', '3d4-l'
            # 'w' is the German form of 'd'
            my @rolls;
            my $number_of_dice = set_num_dice($1, 1); # set number of dice, default 1

            # check that input is not greater than or equal to 100
            # check that input is not 0. ex. 'roll 0d3' should not return a value
            if( $number_of_dice >= 100 or $1 eq '0'){
                return; # do not continue if conditions not met
            }

            my $min = my $number_of_faces = $2; # set min and number_of_faces to max possible roll
            my $max = my $sum = 0; # set max roll and sum to -
            
            for (1 .. $number_of_dice) { # for each die
                my $roll = roll_die( $number_of_faces ); # roll the die
                $min = $roll if $roll < $min; # record min roll
                $max = $roll if $roll > $max; # record max roll
                push @rolls, $roll; # add roll to array rolls
            }
            
            my $modifier = 0;
            if (defined($3) && defined($4)) {
                # handle special case of " - L" or " - H"
                if ($3 eq '-' && ($4 eq 'l' || $4 eq 'h')) {
                    if ($4 eq 'l') {
                        $modifier = -$min; # add -min roll to array rolls
                    } else {
                        $modifier = -$max; # add -max roll to array rolls
                    }
                } elsif ($3 eq '+' && ($4 eq 'l' || $4 eq 'h')) { # do nothing with '3d5+h'
                    return;
                } else {
                   $modifier = int("$3$4"); # ex. '-4', '+3'
                }
            }
            for (@rolls) {
                $sum += $_; # track sum
            }
            $sum += $modifier;
            $total += $sum; # add the local sum to the total
            push @all_rolls, { rolls => \@rolls, total => $sum, standard => 0, multiple => scalar @rolls > 1, faces => $number_of_faces, modifier => $modifier && ($modifier > 0 ? '+' : '').$modifier };
        } else {
            # an element of @value was not valid
            return;
        }
    }

    return unless @all_rolls;

    return join('\n', map { plaintext_output($_) } @all_rolls), structured_answer => {
        id => 'dice',
        name => 'Random Dice',
        result => $total,
        data => {
            rolls => \@all_rolls,
            total => $total,
            show_total => $values > 1
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.dice.content'
            }
        }
    };
};

1;
