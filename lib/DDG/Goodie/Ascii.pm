package DDG::Goodie::Ascii;
# ABSTRACT: ASCII

use strict;
use DDG::Goodie;

triggers end => "ascii";

zci answer_type => "ascii_conversion";
zci is_cached   => 1;

handle remainder => sub {
    my $ascii = pack("B*", $1) if /^(([0-1]{8})*)\s+(in|to)$/;
    my $binary = $1;

    return unless $ascii;

    return "$binary in binary is \"$ascii\" in ASCII",
      structured_answer => {
        input     => [$binary],
        operation => 'Binary to ASCII',
        result    => html_enc($ascii),
      };
};

1;

