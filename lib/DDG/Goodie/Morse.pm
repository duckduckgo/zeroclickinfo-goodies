package DDG::Goodie::Morse;
# ABSTRACT: Converts to/from Morse code

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';
use Convert::Morse qw(is_morse as_ascii as_morse);

triggers start => "morse code for", "morse for";
triggers end => "to morse code", "to morse";

zci answer_type => 'morse';
zci is_cached   => 1;

my $matcher = wi_translation({
    groups => ['imperative', 'conversion'],
    options => {
        command => qr/morse(?: code)? for/i,
        to => qr/morse(?: code)?/i,
    },
});

handle query_raw => sub {
    my $input = shift;

    my $match = $matcher->match($input) or return;
    my $to_morse = $match->{value};
    return if($to_morse =~ /^cheat ?sheet$/);
    my $convertor = is_morse($to_morse) ? \&as_ascii : \&as_morse;
    my $result = $convertor->($to_morse);

    return $result,
      structured_answer => {
        input     => [html_enc($to_morse)],
        operation => 'Morse code conversion',
        result    => html_enc($result),
      };
};

1;
