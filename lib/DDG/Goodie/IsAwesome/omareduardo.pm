package DDG::Goodie::IsAwesome::omareduardo;
# ABSTRACT: omareduardo's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_omareduardo";
zci is_cached   => 1;

triggers start => "duckduckhack omareduardo";

handle remainder => sub {
    return if $_;
    return "omareduardo is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
