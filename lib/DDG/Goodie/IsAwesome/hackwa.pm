package DDG::Goodie::IsAwesome::hackwa;
# ABSTRACT: hackwa's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_hackwa";
zci is_cached   => 1;

triggers start => "duckduckhack hackwa";

handle remainder => sub {
    return if $_;
    return "hackwa is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
