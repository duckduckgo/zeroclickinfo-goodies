package DDG::Goodie::Dice;

use DDG::Goodie;

triggers start => "roll", "throw";

zci answer_type => "dice_roll";

primary_example_queries 'throw dice';
secondary_example_queries 'roll 5 dice', 'roll 3d12';
description 'give the results of a random die throw';
name 'Dice';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Dice.pm';
category 'random';
topics 'math';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

handle remainder => sub {
    if ($_ =~ /^(?:die|(\d{0,2})\s*dice)$/) {
        my @output;
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
            push @output, $roll;
        }
        return join(' ', @output) if @output;
    }
    elsif ($_ =~ /^(\d{0,4})[d|w](\d+)\s?([+-])?\s?(\d+|[lh])?$/) { # 'w' is the German form
        my $output;
        my $number_of_dice = $1 || 1;
        my $number_of_faces = $2;
        my @rolls;
        my $sum = 0;
        for (1 .. $number_of_dice) {
            push(@rolls, int(rand($number_of_faces)) + 1);
        }
        if (defined($3) && defined($4)) {
            # handle special case of " - L" or " - H"
            if ($3 eq '-' && ($4 eq 'l' || $4 eq 'h')) {
                @rolls = sort(@rolls);
                if ($4 eq 'l') {
                    push(@rolls, -(shift(@rolls)));
                } else {
                    push(@rolls, -(pop(@rolls)));
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
            $output = join(' + ', @rolls);
            $output =~ s/\+\s\-/\- /g;
            $output .= " = $sum";
        } else {
            $output = $sum;
        }
        return $output if $output;
    }
    return;
};

1;
