package DDG::Goodie::Lowercase;
# ABSTRACT: Convert a string into lowercase.

use DDG::Goodie;

name "Lowercase";
description "Convert a string into lowercase.";
primary_example_queries "lowercase GitHub";
secondary_example_queries "lower case GitHub";
category 'conversions';
topics 'programming';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Lowercase.pm';
attribution github  => ["https://github.com/DavidMascio", "DavidMascio"];

zci answer_type => "lowercase";
zci is_cached   => 1;

triggers start => 'lowercase', 'lower case', 'lc', 'strtolower', 'tolower';

handle remainder => sub {
    my $input = shift;

    return unless $input;

    my $lower = lc $input;

    return $lower,
      structured_answer => {
        input     => [html_enc($input)],
        operation => 'Lowercase',
        result    => html_enc($lower)
      };
};

1;
