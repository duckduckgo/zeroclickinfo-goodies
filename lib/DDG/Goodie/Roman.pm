package DDG::Goodie::Roman;

use DDG::Goodie;
use Roman;

triggers start => "roman", "arabic";

zci is_cached => 1;
zci answer_type => "RomanNumeralConversion";
handle remainder => sub {
    return uc(roman($_)) if /^\d+$/ && roman($_);
    return arabic $_ if lc($_) =~ /^[mdclxvi]+$/ && arabic($_);
    return;
};

1;
