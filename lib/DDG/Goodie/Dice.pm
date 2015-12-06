package DDG::Goodie::Dice;
# ABSTRACT: roll a number of (abstract) dice.
# https://en.wikipedia.org/wiki/Dice_notation

use strict;
use DDG::Goodie;

triggers start => "roll", "throw";

zci answer_type => "dice_roll";
zci is_cached => 0;

primary_example_queries 'throw dice';
secondary_example_queries 'roll 5 dice', 'roll 3d12', 'roll 3d12 and 2d4', 'roll 2 dice and 3d5';
description 'give the results of a random die throw';
name 'Dice';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Dice.pm';
category 'random';
topics 'math';
attribution cpan    => ['CRZEDPSYC','crazedpsyc'],
            twitter => [ 'loganmccamon', 'loganom'],
            github => ['loganom', 'loganom'];

my %utf8_dice = (
    1 => "\x{2680}",
    2 => "\x{2681}",
    3 => "\x{2682}",
    4 => "\x{2683}",
    5 => "\x{2684}",
    6 => "\x{2685}",
);

# remove whitespace from string
sub remove_whitespace
{
    my $str = $_[0];
    if( defined($str)) {
        $str=~ s/\s//g;
    } else {
        $str='';
    }
    return $str;
}


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
# param left-hand ("lh") or right-hand ("rh")
# param plus ('+') or minus ('-')
# param modifier value e.g. for "1-6dh" the modifier value is '1'
# param is second modifier = determine whether or not a left hand modifier was sent for same roll.
# return roll output
sub shorthand_roll_output {
    my @rolls = @{$_[0]};
    my $sum = $_[1];
    my $right_or_left_hand = $_[2];
    my $plus_or_minus = $_[3];
    my $modifier_value = $_[4];
    my $is_second_modifier = defined($_[5]) ? $_[5] : '0';
    my $out;
    
    if ($is_second_modifier eq '0') {
        if(@rolls > 1) {
            $out = join(' + ', @rolls); # append current roll to output
            $out =~ s/\+\s\-/\- /g; # rewrite + -1 as - 1
        } else {
            $out = $rolls[0];
        }
    } else {
        $out = '';
    }
     
     if($modifier_value ne '0') {
        if($is_second_modifier eq '0') {
            $out = '(' . $out . ')';
        }
        
        if ($right_or_left_hand eq "lh") {
            $out = $modifier_value . ' ' . $plus_or_minus . ' ' . $out;
        } else {
            $out .= ' ' . $plus_or_minus . ' ' . $modifier_value;
        }
     }

    return $out;
}

handle remainder_lc => sub {
    # Ensure rand is seeded for each process
    srand();

    my @values = split(' and ', $_);
    my $values = @values; # size of @values;
    my $out = '';
    my $html = '';
    my $heading = "Random Dice Roll";
    my $total; # total of all dice rolls
    foreach (@values) {
        if ($_ =~ /^(?:a? ?die|(\d{0,2})\s*dic?e)$/) {
            # ex. 'a die', '2 dice', '5dice'
            my @output;
            my $sum = 0;
            my $number_of_dice = set_num_dice($1, 2); # set number of dice, default 2
            my $number_of_faces = 6; # number of utf8_dice
            for (1 .. $number_of_dice) { # for all rolls
                my $roll = roll_die( $number_of_faces ); # roll the die
                $sum += $roll; # track sum
                push @output, $utf8_dice{$roll}; # add our roll to array output
            }
            
            $total += $sum; # track total of all rolls
            $out .= join(', ', @output) . '<br/>';
            $html .= '<span class="zci--dice-die">' . join(' ', @output).'</span>'
                    .'<span class="zci--dice-sum">'." = ". $sum.'</span></br>';
        }
        else {
            # ex. '2d8', '2w6 - l', '3d4 + 4', '3d4-l', '1-4d7', '2+8d2'
            # 'w' is the German form of 'd'
            my (@rolls, $output);
            my $roll_output;
            my $number_of_dice = my $min = 0;
            my $number_of_faces;
            my $max = my $sum = 0; # set max roll and sum to -
            my $modifer_value = '0';
            my $param1 = my $param2 = my $param3 = my $param4 = my $param5 = my $param6 = '';
            my $plus_or_minus = '';

            if ($_ =~ /^(\d+)\s*([+-])\s*(\d*)[d|w](\d*)\s*([+-]?)\s*(\d*)\s*$/) {   # the left hand side of the notation has an "additive modifier" ('1-4d7', '2+8d2')
                                                                                     # and the right hand side may, also: e.g. '1 - 3d7 + 5'
                # remove whitespace
                $param1 = remove_whitespace($1);
                $param2 = remove_whitespace($2);
                $param3 = remove_whitespace($3);
                $param4 = remove_whitespace($4);
                $param5 = remove_whitespace($5);
                $param6 = remove_whitespace($6);
                
                # check that input is not greater than or equal to 99
                # check that input is not 0. ex. 'roll 0d3' should not return a value
                $number_of_dice = set_num_dice($param3, 1);
                if( $number_of_dice >= 100 or $param3 eq '0'){
                     return; # do not continue if conditions not met
                }
                
                $min = $number_of_faces = $param4;         
                $modifer_value = $param1;
                $plus_or_minus = $param2;

                # TODO: refactor code from here to end of block to call one or more subroutines that can be used by the next section.
                for (1 .. $number_of_dice) { # for each die
                    my $roll = roll_die( $number_of_faces ); # roll the die
                    $min = $roll if $roll < $min; # record min roll
                    $max = $roll if $roll > $max; # record max roll
                    push @rolls, $roll; # add roll to array rolls
                }
                
                for (@rolls) {
                    $sum += $_; # track sum
                }

                # Identify the modifier and store it for formatting and total.
                if($plus_or_minus eq '-') { # the modifier is a minus sign ("-")
                    $sum = int($modifer_value) - $sum;
                } else {
                    $sum = int($modifer_value) + $sum;
                }
                $roll_output = shorthand_roll_output( \@rolls, $sum, "lh", $plus_or_minus, $modifer_value ); # initialize roll_output
                
				if($param5 ne '' && $param6 ne '') {   # check right-hand side for '+n' or '-n'
					if( $param5 eq '+' || $param5 eq '-') {
                        $plus_or_minus = $param5;
                        $modifer_value = $param6;
                        
                        if($plus_or_minus eq '-') {
                            $sum = $sum - int($modifer_value);
                        } else {
                            $sum = int($modifer_value) + $sum;
                        }
					}
                
                    $roll_output .= shorthand_roll_output( \@rolls, $sum, "rh", $plus_or_minus, $modifer_value, '1' ); # initialize roll_output
				}
                
                if( @rolls > 1) {
                    $roll_output .= " = $sum";
                }
                $roll_output .= '<br/>';
                $out .= $roll_output; # add roll_output to our result
                $html .= $roll_output; # add roll_output to our HTML result
                $total += $sum; # add the local sum to the total
            }
            elsif ($_ =~ /^(\d*)[d|w](\d+)\s?([+-])?\s?(\d+|[lh])?$/) { # no modifier or only a right-hand modifier: e.g. 6d7 or 2d9=3
                # remove whitespace
                $param1 = remove_whitespace($1);
                $param2 = remove_whitespace($2);
                $param3 = remove_whitespace($3);
                $param4 = remove_whitespace($4);
                
                # check that input is not greater than or equal to 99
                # check that input is not 0. ex. 'roll 0d3' should not return a value
                $number_of_dice = set_num_dice($1, 1); # set number of dice, default 1                
                if( $number_of_dice >= 100 or $1 eq '0'){
                     return; # do not continue if conditions not met
                }
                
                $min = $number_of_faces = $param2; # set min and number_of_faces to max possible roll
                for (1 .. $number_of_dice) { # for each die
                    my $roll = roll_die( $number_of_faces ); # roll the die
                    $min = $roll if $roll < $min; # record min roll
                    $max = $roll if $roll > $max; # record max roll
                    push @rolls, $roll; # add roll to array rolls
                }
                
                if ($param3 ne '' && $param4 ne '') {
                    # handle special case of " - L" or " - H"
                    if ($param3 eq '-' && ($param4 eq 'l' || $param4 eq 'h')) {
                        if ($param4 eq 'l') {
                            push(@rolls, -$min); # add -min roll to array rolls
                        } else {
                            push(@rolls, -$max); # add -max roll to array rolls
                        }
                    } elsif ($param3 eq '+' && ($param4 eq 'l' || $param4 eq 'h')) { # do nothing with '3d5+h'
                    return;
                    } else {
                        $plus_or_minus = $param3;
                        $modifer_value = $param4;
                    }
                }
                
                for (@rolls) {
                    $sum += $_; # track sum
                }
                
                $roll_output = shorthand_roll_output( \@rolls, $sum, "rh", $plus_or_minus, $modifer_value ); # initialize roll_output
                if( @rolls > 1) {
                    $roll_output .= " = $sum";
                }
                $roll_output .= '<br/>';
                $out .= $roll_output; # add roll_output to our result
                $html .= $roll_output; # add roll_output to our HTML result
                $total += $sum; # add the local sum to the total
            }
            else{
                # an element of @value was not valid
                return;
            }
        }
    }
    if($values > 1) {
        # display total sum if more than one value was specified
        $out .= 'Total: ' . $total;
        $html .= 'Total: ' . $total;
    }
    $out =~ s/<br\/>$//g; # remove trailing newline
    if($out eq ''){
        return;
        }else{
        return  answer => $out,
                html => $html,
                heading => $heading;
    }
};

1;
