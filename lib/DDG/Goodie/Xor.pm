package DDG::Goodie::Xor;

use DDG::Goodie;
use utf8;

triggers any => 'xor', '⊕', 'and', '∧', 'or', '∨';

zci is_cached => 1;
zci answer_type => "xor";

attribution
    github => ['https://github.com/MithrandirAgain', 'MithrandirAgain'];

primary_example_queries '4 xor 5';
secondary_example_queries 
    '5 ⊕ 79', 
    '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985', 
    '10 and 12',
    '12 ∧ 23',
    '34 or 100',
    '4567 ∨ 2311',
    '10 and (30 or 128)',
    '0x345 ∧ 0b010010101 ∨ 7890';
description 'take two numbers and do bitwise logical operations (exclusive-or, or, and) on them';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Xor.pm';
category 'calculations';
topics 'math';

handle query_raw => sub {
    my @tokens = split(/\s+/i, $_);
    my $cmd = '';

    foreach (@tokens) {
        if (/^(xor|⊕)$/) {
            $cmd = $cmd . '^ ';
        }
        elsif (/^(and|∧)$/) {
            $cmd = $cmd . '& ';
        }
        elsif (/^(or|∨)$/) {
            $cmd = $cmd . '| ';
        }
        elsif (/^(\(|\))$/) {
            $cmd = $cmd . $_;
        }
        elsif (/\d+/) {
            $cmd = $cmd . $_ . ' ';
        }
        else {
            return;
        }
    }

    return eval($cmd) or return;
};

1;
