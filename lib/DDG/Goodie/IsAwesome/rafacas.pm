package DDG::Goodie::IsAwesome::rafacas;
# ABSTRACT: rafacas' first Goodie 

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_rafacas";
zci is_cached   => 1;

triggers start => "duckduckhack rafacas";

handle remainder => sub {
        return if $_;
	return "rafacas is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
