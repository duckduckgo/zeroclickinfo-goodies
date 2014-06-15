package DDG::Goodie::Uppercase;

use DDG::Goodie;

triggers startend => 'uppercase', 'upper case';

zci is_cached => 1;
zci answer_type => "uppercase";

primary_example_queries   'uppercase this';
secondary_example_queries 'upper case that';

name        'Uppercase';
description 'Make a string uppercase.';
code_url    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Uppercase.pm';
category    'conversions';
topics      'programming';

attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

handle remainder => sub { uc ($_) };

1;
