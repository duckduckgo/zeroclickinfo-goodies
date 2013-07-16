package DDG::Goodie::Or; 

use DDG::Goodie;
use utf8;

triggers any => 'or', '∨';

zci is_cached => 1;
zci answer_type => "or";

attribution
    github => ['https://github.com/Spixi', 'Spixi (based on Xor.pm by MithrandirAgain)'];

primary_example_queries '9 or 5';
secondary_example_queries '5 ∨ 59', '86 or 8209 or 4293 or 4129';
description 'take two numbers and do a bitwise or operation on them';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Or.pm';
category 'calculations';
topics 'math';

handle query_raw => sub {
    my @nums = grep(!/(or|∨)/, split(/\s+(∨|or)\s+/i, $_));
    my $num = 0;
    foreach (@nums) {
        $num |= $_ if /^\d+$/;
        return unless /^\d+$/;
    }
    return "$num" if $num;
    return;
};

1;
