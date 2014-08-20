package DDG::Goodie::Xor;
# ABSTRACT: bitwise XOR two numbers.

use DDG::Goodie;
use utf8;

triggers any => 'xor', '⊕';

zci is_cached => 1;
zci answer_type => "xor";

attribution
    github => ['https://github.com/MithrandirAgain', 'MithrandirAgain'];

primary_example_queries '4 xor 5';
secondary_example_queries '5 ⊕ 79', '9489 xor 394 xor 9349 xor 39 xor 29 xor 4967 xor 3985';
description 'take two numbers and do a bitwise exclusive-or operation on them';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Xor.pm';
category 'calculations';
topics 'math';

handle query_raw => sub {
    my @nums = grep(!/(xor|⊕)/, split(/\s+(⊕|xor)\s+/i, $_));
    my $num = 0;
    foreach (@nums) {
        $num ^= $_ if /^\d+$/;
        return unless /^\d+$/;
    }
    return "$num" if $num;
    return;
};

1;
