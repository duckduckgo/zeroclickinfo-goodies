package DDG::Goodie::IsAwesome::justinvee;
# ABSTRACT: justinvee's first Goodie.

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_justinvee";
zci is_cached   => 1;

triggers start => "duckduckhack justinvee";

handle remainder => sub {

	return if $_; # Guard against "no answer"

	return "justinvee is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
