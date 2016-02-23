package DDG::Goodie::IsAwesome::Dronov;
# ABSTRACT: Dronov's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_dronov";
zci is_cached   => 1;

triggers start => "duckduckhack dronov";

handle remainder => sub {
    return if $_;
    return "Mikhail Dronov is awesome and has successfully completed the DuckDuckHack Goodie tutorial! He's saying hello from far cold Russia. Find him at dronov.net";
};

1;
