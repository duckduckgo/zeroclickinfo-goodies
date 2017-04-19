package DDG::Goodie::And;

use DDG::Goodie;
use utf8;

triggers any => 'and', '∧', 'et';

zci is_cached => 1;
zci answer_type => "and";

attribution
    github => ['https://github.com/Spixi', 'Spixi (based on Xor.pm by MithrandirAgain)'];

primary_example_queries '4 and 5';
secondary_example_queries '5 ∧ 79', '7607 and 13444 and 5831 and 11077';
description 'take two numbers and do a bitwise and operation on them';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/And.pm';
category 'calculations';
topics 'math';

handle query_raw => sub {
    my @nums = grep(!/(and|et|∧)/, split(/\s+(∧|et|and)\s+/i, $_));
    my $num = 0;
    foreach (@nums) {
        $num &= $_ if /^\d+$/;
        return unless /^\d+$/;
    }
    return "$num" if $num;
    return;
};

1;
