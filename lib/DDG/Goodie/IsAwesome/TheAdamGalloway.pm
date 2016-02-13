package DDG::Goodie::IsAwesome::TheAdamGalloway;
# ABSTRACT: TheAdamGalloway's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_the_adam_galloway";
zci is_cached   => 1;

triggers start => "duckduckhack theadamgalloway";

handle remainder => sub {
    return if $_;
    return "TheAdamGalloway is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
