package DDG::Goodie::GoldenRatio;
# ABSTRACT: find number related to the given number by the Golden Ratio.

use strict;
use DDG::Goodie;

zci answer_type => 'golden_ratio';

zci is_cached => 1;

triggers start => 'golden ratio';

sub answer {
    my ($ratio, $explanation) = @_;

    return "Golden ratio: $ratio", structured_answer => {
        data => {
            title => "$ratio",
            subtitle => "$explanation"
        },
        templates => {
            group => 'text'
        }
    };
}

handle remainder => sub {
    my $input = $_;
    my $golden_ratio = (1 + sqrt(5)) / 2;
    my $result = 0;

    if ($input =~ /^(?:(?:(\?)\s*:\s*(\d+(?:\.\d+)?))|(?:(\d+(?:\.\d+)?)\s*:\s*(\?)))$/) {
        if ($1 && $1 eq '?') {
            # ? : x
            $result = $2 / $golden_ratio;
            return answer("$result:$2", "Golden ratio for ?:$2");
        } elsif ($4 && $4 eq '?') {
            # x : ?
            $result = $3 * $golden_ratio;
            return answer("$3:$result", "Golden ratio for $3:?");
        }
    }
    return;
};
1;
