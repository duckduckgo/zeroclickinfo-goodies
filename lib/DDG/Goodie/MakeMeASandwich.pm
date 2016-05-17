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
            result => $result,
            input => $input
        },
        templates => {
            options => {
                content => 'DDH.make_me_asandwich.content'
            },
            group => 'text'
        }
    };
};

1;
