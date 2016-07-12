package DDG::Goodie::FlipText;
# ABSTRACT: appear to flip text upside down via UNICODE.

use strict;
use DDG::Goodie;

use Text::UpsideDown;

triggers start => "flip text", "mirror text", "spin text", "rotate text";

zci answer_type => "flip_text";
zci is_cached   => 1;

handle remainder => sub {
    my $input = $_;

    return unless $input;

    my $result = upside_down($input);

    return $result,
      structured_answer => {
        data => {
            title    => $result,
            subtitle => "Flip text $input"
        },
        templates => {
            group => 'text',
        }
      };
};

1;
