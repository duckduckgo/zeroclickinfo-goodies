package DDG::Goodie::Dice;

use DDG::Goodie;

triggers start => "roll", "throw";

zci answer_type => "dice_roll";

primary_example_queries 'throw dice';
secondary_example_queries 'roll 5 dice', 'roll 3d12', 'roll 3d12 and 2d4';
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
    my $total; # total of all dice rolls (for "roll 2d5" form)
    foreach my $_ (@values) {
        if ($_ =~ /^(?:a? ?die|(\d{0,2})\s*dic?e)$/) {
            my @output;
            my $sum = 0;
            my $rolls = 1;  # If "die" is entered
            my $choices = 6;  # To be replace with input string in the future
            if (defined($1)) {    # Not defined if number of "dice" not specified
                if ($1 eq "") {
                    $rolls = 2;
                }
                else {
                    $rolls = $1;
                }
            }
            for (1 .. $rolls) {
                my $roll = int(rand($choices)) + 1;
                $sum += $roll;
                push @output, $utf8_dice{$roll};
            }
            $total += $sum;
            $roll_output .= join(', ', @output) . '<br/>';
            $html_output .= '<span style="font-size:14pt;">' . join(', ', @output) . '</span> = ' . $sum .'<br/>';
        }
        elsif ($_ =~ /^(\d*)[d|w](\d+)\s?([+-])?\s?(\d+|[lh])?$/) { # 'w' is the German form
            my (@rolls, $output);
            my $number_of_dice = $1 || 1;
            if( $number_of_dice >= 100){
                return; # do not continue
            }
            my $lowest = my $number_of_faces = $2;
            my $highest = my $sum = 0;
            for (1 .. $number_of_dice) {
                my $roll = int(rand($number_of_faces)) + 1;
                $lowest = $roll if $roll < $lowest;
                $highest = $roll if $roll > $highest;
                push @rolls, $roll;
            }
            if (defined($3) && defined($4)) {
                # handle special case of " - L" or " - H"
                if ($3 eq '-' && ($4 eq 'l' || $4 eq 'h')) {
                    if ($4 eq 'l') {
                        push(@rolls, -$lowest);
                    } else {
                        push(@rolls, -$highest);
                    }
                } elsif ($3 eq '+' && ($4 eq 'l' || $4 eq 'h')) {
                    return;
                } else {
                    push(@rolls, int("$3$4"));
                }
            }
            for (@rolls) {
                $sum += $_;
            }
            if (@rolls > 1) {
                $output = join(' + ', @rolls); # append current roll to output
                $output =~ s/\+\s\-/\- /g; 
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
