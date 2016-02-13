package DDG::Goodie::IsAwesome::thejdeep;
# ABSTRACT: thejdeep's first Goodie !

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_thejdeep";
zci is_cached   => 1;

triggers start => "duckduckhack thejdeep";

handle remainder => sub {
    return if $_;
    return "thejdeep is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
