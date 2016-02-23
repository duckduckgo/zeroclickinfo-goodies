package DDG::Goodie::IsAwesome::vedantham;
# ABSTRACT: Vendatham's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_vedantham";
zci is_cached   => 1;

triggers start => "duckduckhack vedantham";

handle remainder => sub {
    return if $_;
    return "vedantham is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
