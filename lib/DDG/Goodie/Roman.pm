package DDG::Goodie::Roman;
# ABSTRACT: Convert between Roman and Arabic numeral systems.

use DDG::Goodie;

use Roman;

primary_example_queries 'roman numeral MCCCXXXVII';
secondary_example_queries 'roman 1337', 'roman IV';
description 'convert between Roman and Arabic numerals';
name 'Roman Numerals';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Roman.pm';
category 'conversions';
topics 'cryptography';

attribution github => ['https://github.com/mrshu', 'mrshu'];

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
