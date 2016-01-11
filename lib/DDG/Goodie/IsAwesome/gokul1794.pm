package DDG::Goodie::IsAwesome::gokul1794;
# ABSTRACT: gokul1794's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_gokul1794";
zci is_cached   => 1;

triggers start => "duckduckhack gokul1794";

handle remainder => sub {
    return if $_;
    return "gokul1794 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
