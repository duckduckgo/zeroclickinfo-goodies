package DDG::Goodie::MakeMeASandwich;
# ABSTRACT: XKCD #149 Easter Egg

use strict;
use DDG::Goodie;

triggers end => 'make me a sandwich';

zci answer_type => 'xkcd_sandwich';
zci is_cached   => 1;

my $xkcd_query = 'https://duckduckgo.com/?q=' . uri_esc('xkcd 149');
my $operation  = '<a href="' . $xkcd_query . '">xkcd 149</a>';

handle remainder => sub {

    my $rem = lc $_;

    my ($result, $input) = (undef, 'make me a sandwich');
    if ($rem eq 'sudo') {
        $result = 'Okay.';
        $input  = 'sudo ' . $input;
    } elsif ($rem eq '') {
        $result = 'What? Make it yourself.';
    }

    return unless defined $result;

    return $result,
      structured_answer => {
        input     => [$input],
        operation => $operation,
        result    => $result
      };
};

1;
