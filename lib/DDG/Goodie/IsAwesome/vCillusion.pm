package DDG::Goodie::IsAwesome::vCillusion;
# ABSTRACT: vCillusion's first Goodie

use DDG::Goodie;
use strict;

zci answer_type             => "is_awesome_vcillusion";
zci is_cached               => 1;

triggers start      => "duckduckhack vcillusion";

handle remainder    => sub {

	return if $_; # Guard against "no answer"

	return "vCillusion is awesome and is keen to learn new things!";
};

1;
