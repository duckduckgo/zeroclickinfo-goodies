package DDG::Goodie::MakeMeASandwich;
# ABSTRACT: XKCD #149 Easter Egg

use strict;
use DDG::Goodie;

triggers end => 'make me a sandwich';

zci answer_type => 'xkcd_sandwich';
zci is_cached   => 1;

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

    return $result, structured_answer => {
        data => {
            title => $result,
            subtitle => [
                $input,
                { text => "XKCD 149", href => "https://duckduckgo.com/?q=xkcd%20149" }
            ]
        },
        templates => {
            group => 'text'
        }
    };
};

1;
