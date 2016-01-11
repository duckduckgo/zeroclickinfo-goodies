package DDG::Goodie::Lowercase;
# ABSTRACT: Convert a string into lowercase.

use strict;
use DDG::Goodie;

zci answer_type => "lowercase";
zci is_cached   => 1;

triggers start => 'lowercase', 'lower case', 'lc', 'strtolower', 'tolower';

handle remainder => sub {
    my $input = shift;

    return unless $input;

    my $lower = lc $input;

    return if ($lower eq $input);

    return $lower,
      structured_answer => {
        input     => [html_enc($input)],
        operation => 'Lowercase',
        result    => html_enc($lower)
      };
};

1;
