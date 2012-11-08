package DDG::Goodie::Chars;
# ABSTRACT: Give the number of characters (length) of the query.

use DDG::Goodie;

triggers start => 'chars';

zci is_cached => 1;
zci answer_type => "chars";

primary_example_queries 'chars test';
secondary_example_queries 'chars this is a test';
description 'count the number of charaters in a query';
name 'Chars';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Chars.pm';
category 'computing_tools';
topics 'programming';

handle remainder => sub {
    return "Chars: " .length $_ if $_;
    return;
};

1;
