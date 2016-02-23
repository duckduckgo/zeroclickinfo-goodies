package DDG::Goodie::IsAwesome::davehtaylor;
# ABSTRACT: davehtaylor's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_davehtaylor";
zci is_cached   => 1;

triggers start => "duckduckhack davehtaylor";

handle remainder => sub {
    return if $_;
	return "davehtaylor is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
