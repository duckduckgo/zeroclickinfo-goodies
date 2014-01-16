package DDG::Goodie::Dice;

use DDG::Goodie;

triggers start => "roll", "throw";

zci answer_type => "dice_roll";

primary_example_queries 'throw dice';
secondary_example_queries 'roll 5 dice', 'roll 3d12', 'roll 3d12 and 2d4', 'roll 2 dice and 3d5';
description 'give the results of a random die throw';
name 'Dice';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Dice.pm';
category 'random';
topics 'math';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC',
            twitter => 'loganmccamon',
            github => 'loganom' ;

my %utf8_dice = (
    1 => "\x{2680}",
    2 => "\x{2681}",
    3 => "\x{2682}",
    4 => "\x{2683}",
    5 => "\x{2684}",
    6 => "\x{2685}",
);

handle remainder_lc => sub {
    my @values = split(' and ', $_);
    my $values = @values; # size of @values;
    my $roll_output = '';
    my $html_output = ''; 
    my $heading = "Random Dice Roll";
    my $total; # total of all dice rolls
    foreach my $_ (@values) {
        if ($_ =~ /^(?:a? ?die|(\d{0,2})\s*dic?e)$/) { 
            # ex. 'a die', '2 dice', '5dice'
            my @output;
            my $sum = 0;
            my $rolls = 1; # initialize rolls
            my $choices = 6; # number of utf8_dice
            if (defined($1)) {    # defined if term 'dice' used
                if ($1 eq "") {
                    $rolls = 2; # if term 'dice' used without number, default 2
                } else {
                    $rolls = $1; # used with number, roll n times
                }
            }
            for (1 .. $rolls) { # for all rolls
                my $roll = int(rand($choices)) + 1; # pseudo random roll
                $sum += $roll; # track sum
                push @output, $utf8_dice{$roll}; # add our roll to array output
            }
            $total += $sum; # track total of all rolls
            $roll_output .= join(', ', @output) . '<br/>';
            $html_output .= '<span style="font-size:14pt;">' . join(', ', @output) . '</span> = ' . $sum .'<br/>';
        }
        elsif ($_ =~ /^(\d*)[d|w](\d+)\s?([+-])?\s?(\d+|[lh])?$/) { 
            # ex. '2d8', '2w6 - l', '3d4 + 4', '3d4-l'
            # 'w' is the German form of 'd'
            my (@rolls, $output);
            my $number_of_dice = $1 || 1; # if no number of dice specified, default 1
            if( $number_of_dice >= 100){
                return; # do not continue
            }
            my $lowest = my $number_of_faces = $2; # set lowest and number_of_faces to max possible roll
            my $highest = my $sum = 0; # set highest roll and sum to -
            for (1 .. $number_of_dice) { # for each die
                my $roll = int(rand($number_of_faces)) + 1; # pseudo random roll
                $lowest = $roll if $roll < $lowest; # record lowest roll
                $highest = $roll if $roll > $highest; # record highest roll
                push @rolls, $roll; # add roll to array rolls
            }
            if (defined($3) && defined($4)) {
                # handle special case of " - L" or " - H"
                if ($3 eq '-' && ($4 eq 'l' || $4 eq 'h')) {
                    if ($4 eq 'l') {
                        push(@rolls, -$lowest); # add -lowest roll to array rolls
                    } else {
                        push(@rolls, -$highest); # add -highest roll to array rolls
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
            if (@rolls > 1) { # if( sizeOf(rolls) > 1)
                $output = join(' + ', @rolls); # append current roll to output
                $output =~ s/\+\s\-/\- /g; # rewrite + -1 as - 1
                $output .= " = $sum"; # append sum of rolls to output
            } else {
                $output = $sum; # output is roll value if we have just one roll
            }
            $roll_output .= $output . '<br/>'; # add output to our result
            $html_output .= $output . '<br/>'; # add output to our html result
            $total += $sum; # add the local sum to the total
        }else{
            # an element of @value was not valid
            return;
        }
    }
    if($values > 1) {
        # display total sum if more than one value was specified
        $roll_output .= 'Total: ' . $total;
        $html_output .= 'Total: ' . $total;
    }
    $roll_output =~ s/<br\/>$//g; # remove trailing newline 
    if($roll_output eq ''){
        return; # nothing to return
    }else{
        return  answer => $roll_output,
                html => $html_output,
                heading => $heading;
    }
};

1;
