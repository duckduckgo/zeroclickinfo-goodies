package DDG::Goodie::Morse;
# ABSTRACT: Converts to/from Morse code

use strict;
use DDG::Goodie;
use Convert::Morse qw(is_morse as_ascii as_morse);

triggers start => "morse code for", "morse for";
triggers end => "to morse code", "to morse";

zci answer_type => 'morse';
zci is_cached   => 1;

handle remainder => sub {
    my $input = shift;

    return unless $input;
    return if($input eq 'cheat sheet');
    return if($input eq 'cheatsheet');
    my $convertor = is_morse($input) ? \&as_ascii : \&as_morse;
    my $result = $convertor->($input);

    return $result, structured_answer => {
        data => {
            title => $result,
            subtitle => "Morse code conversion: $input"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
