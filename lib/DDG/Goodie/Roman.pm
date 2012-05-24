package DDG::Goodie::Roman;

use DDG::Goodie;
use Roman;

triggers any => "roman", "arabic";

zci is_cached => 1;
zci answer_type => "roman_numeral_conversion";

handle remainder => sub {
    s/\s*(?:numeral|number)\s*//i;
    return uc(roman($_)) . ' (roman numeral conversion)' if /^\d+$/ && roman($_);
    return arabic($_) . ' (roman numeral conversion)' if lc($_) =~ /^[mdclxvi]+$/ && arabic($_);
    return;
};

1;
