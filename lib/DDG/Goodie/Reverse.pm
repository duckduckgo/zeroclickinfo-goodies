package DDG::Goodie::Reverse;
# ABSTRACT: Reverse the order of chars in the remainder

use DDG::Goodie;

primary_example_queries 'reverse esrever';
description 'reverse the order of the characters in your query';
name 'Reverse';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Reverse.pm';
category 'transformations';
topics 'words_and_games';

attribution github => ['https://github.com/Getty', 'Getty'], cpan => 'GETTY';

triggers startend => "reverse";

zci is_cached => 1;
zci answer_type => "reverse";

handle remainder => sub { qq|Reversed "$_": | . scalar reverse };

1;
