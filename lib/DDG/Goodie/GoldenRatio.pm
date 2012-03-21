package DDG::Goodie::GoldenRatio;

use DDG::Goodie;

zci answer_type => "GoldenRatio";

zci is_cached => 1;

triggers start => "golden"; # should be "golden ratio"

handle query_parts => sub {
    shift;
    return unless lc(shift) eq "ratio";
    my $input = join(' ', @_);
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
