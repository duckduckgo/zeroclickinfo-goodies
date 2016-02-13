package DDG::Goodie::IsAwesome::valnermedeiros;
# ABSTRACT: valnermedeiros's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_valnermedeiros";
zci is_cached   => 1;

triggers start => "duckduckhack valnermedeiros";

handle remainder => sub {
	return if $_;
	return "ValnerMedeiros is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
