package DDG::Goodie::IsAwesome::Bitflipped;
# ABSTRACT: Bitflipped's first Goodie

use DDG::Goodie;
use strict;

zci answer_type             => "is_awesome_bitflipped";
zci is_cached               => 1;

triggers start      => "duckduckhack bitflipped";

handle remainder    => sub {

	return if $_; # Guard against "no answer"

	return "bitflipped is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
