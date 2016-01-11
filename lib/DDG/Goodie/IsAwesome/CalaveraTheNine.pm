package DDG::Goodie::IsAwesome::CalaveraTheNine;
# ABSTRACT: CalaveraTheNine's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_calavera_the_nine";
zci is_cached   => 1;

triggers start => "duckduckhack calaverathenine";

handle remainder => sub {
    return if $_;
    return "CalaveraTheNine is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
