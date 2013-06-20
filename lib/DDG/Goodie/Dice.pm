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

my %utf8_dice = (
    1 => "\x{2680}",
    2 => "\x{2681}",
    3 => "\x{2682}",
    4 => "\x{2683}",
    5 => "\x{2684}",
    6 => "\x{2685}",
);

handle remainder_lc => sub {
    if ($_ =~ /^(?:a? ?die|(\d{0,2})\s*dic?e)$/) {
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
            push @output, $utf8_dice{$roll};
        }
        return join(', ', @output) . ' (random)', html => '<span style="font-size:14pt;">' . join(', ', @output) . ' (random)</span>' if @output;
    }
    elsif ($_ =~ /^(\d{0,4})[d|w](\d+)\s?([+-])?\s?(\d+|[lh])?$/) { # 'w' is the German form
        my $output;
        my $number_of_dice = $1 || 1;
        my $number_of_faces = $2;
        my @rolls;
        my $sum = 0;
        for (1 .. $number_of_dice) {
            push @rolls, int(rand($number_of_faces)) + 1;
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
        return '' . $output . ' (random)' if $output;
    }
    return;
};

1;
