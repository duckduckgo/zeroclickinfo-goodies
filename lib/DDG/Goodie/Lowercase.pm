package DDG::Goodie::Lowercase;
use DDG::Goodie;

# ABSTRACT: Convert a string into lowercase.
name "Lowercase";
description "Convert a string into lowercase.";
primary_example_queries "lowercase GitHub";
secondary_example_queries "lower case GitHub";
category 'conversions';
topics 'programming';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Lowercase.pm';
attribution github  => ["DavidMascio"];

zci is_cached => 1;
zci answer_type => "lowercase";

triggers start => 'lowercase', 'lower case';

handle remainder => sub {
    return lc $_ if $_;
    return;
};

1;
