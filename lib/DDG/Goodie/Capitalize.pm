package DDG::Goodie::Capitalize;

use DDG::Goodie;

triggers startend => 'capitalize', 'uppercase', 'upper case';

zci is_cached => 1;
zci answer_type => "capitalize";

primary_example_queries 'capitalize this';
secondary_example_queries 'uppercase that';
description 'capitalize a string';
name 'Capitalize';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Capitalize.pm';
category 'conversions';
topics 'programming';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;


handle remainder => sub { uc ($_) };

1;
