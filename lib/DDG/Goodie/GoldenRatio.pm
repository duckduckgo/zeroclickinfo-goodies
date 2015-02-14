package DDG::Goodie::GoldenRatio;
# ABSTRACT: find number related to the given number by the Golden Ratio.

use DDG::Goodie;

zci answer_type => "golden_ratio";

zci is_cached => 1;

triggers start => "golden ratio";

primary_example_queries 'golden ratio 900:?';
secondary_example_queries 'golden ratio ?:123.345';
description 'find the number in the golden ratio with a number';
name 'GoldenRatio';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GoldenRatio.pm';
category 'calculations';
topics 'math';
attribution twitter => ['crazedpsyc','crazedpsyc'],
            cpan    => ['CRZEDPSYC','crazedpsyc'];

handle remainder => sub {
    my $input = $_;
    my $golden_ratio = (1 + sqrt(5)) / 2;
    my $result = 0;

    if ($input =~ /^(?:(?:(\?)\s*:\s*(\d+(?:\.\d+)?))|(?:(\d+(?:\.\d+)?)\s*:\s*(\?)))$/) {
        if ($1 && $1 eq "?") {
            # ? : x
            $result = $2 / $golden_ratio;
            return "Golden ratio: $result : $2";
        } elsif ($4 && $4 eq "?") {
            # x : ?
            $result = $3 * $golden_ratio;
            return "Golden ratio: $3 : $result";
        }
    }
    return;
};
1;
