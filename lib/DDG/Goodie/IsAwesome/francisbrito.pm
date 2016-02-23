package DDG::Goodie::IsAwesome::francisbrito;
# ABSTRACT: francisbrito's first goodie.

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_francisbrito";
zci is_cached   => 1;

triggers start => "duckduckhack francisbrito";

handle remainder => sub {
    return if $_;
    return "francisbrito is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
