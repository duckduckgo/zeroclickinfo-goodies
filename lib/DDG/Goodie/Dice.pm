package DDG::Goodie::Dice;
# ABSTRACT: roll a number of (abstract) dice.
# https://en.wikipedia.org/wiki/Dice_notation

use strict;
use DDG::Goodie;
use Lingua::EN::Numericalize;

triggers start => "roll", "throw";

zci answer_type => "dice_roll";
zci is_cached => 0;

my %utf8_dice = (
    1 => "\x{2680}",
    2 => "\x{2681}",
    3 => "\x{2682}",
    4 => "\x{2683}",
    5 => "\x{2684}",
    6 => "\x{2685}",
);

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
        if ($num_dice =~ /^[a-zA-Z\s\-]+$/) {
            return str2nbr($num_dice);
        }
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
sub shorthand_roll_output {
    my @rolls = @{$_[0]};
    my $sum = $_[1];
    my $out;
    if (@rolls > 1) { # if( sizeOf(rolls) > 1)
        $out = join(' + ', @rolls); # append current roll to output
        $out =~ s/\+\s\-/\- /g; # rewrite + -1 as - 1
        if ($_[2] > 1) {
            $out .= " = $sum"; # append sum of rolls to output
        }
    } else {
        $out = $sum; # output is roll value if we have just one roll
    }
    return $out;
}

handle remainder_lc => sub {
    # Ensure rand is seeded for each process
    srand();

    my @values = split(' and ', $_);
    my $values = @values; # size of @values;
    my $out = '';
    my $diceroll;
    my @result;
    my $heading = "Random Dice Roll";
    my $total; # total of all dice rolls
    foreach (@values) {
        if ($_ =~ /^(?:a? ?die|(\d{0,2}|[a-zA-Z\s\-]+)\s*dic?es?)$/) {
            # ex. 'a die', '2 dice', '5dice', 'five dice'
            my @output;
            my $sum = 0;
            my $number_of_dice = set_num_dice($1, 2); # set number of dice, default 2
            my $number_of_faces = 6; # number of utf8_dice

            if ($number_of_dice !~ /^\d+$/) {
                return;
            }
            for (1 .. $number_of_dice) { # for all rolls
                my $roll = roll_die( $number_of_faces ); # roll the die
                $sum += $roll; # track sum
                push @output, $utf8_dice{$roll}; # add our roll to array output
            }
            $total += $sum; # track total of all rolls
            $out .= join(', ', @output);
            $diceroll = join(' ', @output);
            push @result, {
                'sum' => $sum,
                'rolls' => $diceroll,
                'isdice' => 1
            };
        }
        elsif ($_ =~ /^(\d*)[d|w](\d+)\s?([+-])?\s?(\d+|[lh])?$/) {
            # ex. '2d8', '2w6 - l', '3d4 + 4', '3d4-l'
            # 'w' is the German form of 'd'
            my (@rolls, $output);
            my $number_of_dice = set_num_dice($1, 1); # set number of dice, default 1
            # check that input is not greater than or equal to 99
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
            if (defined($3) && defined($4)) {
                # handle special case of " - L" or " - H"
                if ($3 eq '-' && ($4 eq 'l' || $4 eq 'h')) {
                    if ($4 eq 'l') {
                        push(@rolls, -$min); # add -min roll to array rolls
                    } else {
                        push(@rolls, -$max); # add -max roll to array rolls
                    }
                } elsif ($3 eq '+' && ($4 eq 'l' || $4 eq 'h')) { # do nothing with '3d5+h'
                    return;
                } else {
                    push(@rolls, int("$3$4")); # ex. '-4', '+3'
                }
            }
            for (@rolls) {
                $sum += $_; # track sum
            }
            my $roll_output = shorthand_roll_output( \@rolls, $sum, $values ); # initialize roll_output
            $out .= $roll_output; # add roll_output to our result
            push @result, {
                'sum' => $sum,
                'rolls' => [@rolls],
                'isdice' => 0
            };
            $total += $sum; # add the local sum to the total
        }else{
            # an element of @value was not valid
            return;
        }
    }
    my $group = 'text';
    
    my $data = {
        title => $total,
        list => \@result
    };
    
    my $options = {
        subtitle_content => 'DDH.dice.subtitle_content'
    };
    
    if ($values > 1) {
        # display total sum if more than one value was specified
        $out .= 'Total: ' . $total;
        $group = 'list';
        $options = {
            list_content => 'DDH.dice.content'
        };
    }
    $out =~ s/<br\/>$//g; # remove trailing newline
    
    if ($out eq '') {
        return; # nothing to return
    }
    
    return  $out,
    structured_answer => {
        id => 'dice',
        name => 'Answer',
        data => $data,
        templates => {
            group => $group,
            options => $options
        }
   };
    
};

1;
