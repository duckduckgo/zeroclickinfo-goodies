package DDG::Goodie::IsAwesome::SueSmith;
# ABSTRACT: SueSmith's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_sue_smith";
zci is_cached   => 1;

triggers start => "duckduckhack suesmith";

handle remainder => sub {

    return if $_;
	return "SueSmith is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
