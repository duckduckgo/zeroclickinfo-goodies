package DDG::Goodie::IsAwesome::alexishancock;
# ABSTRACT: alexishancock's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_alexishancock";
zci is_cached   => 1;

triggers start => "duckduckhack alexishancock";

handle remainder => sub {
    return if $_;
    return "Alexis Hancock is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
