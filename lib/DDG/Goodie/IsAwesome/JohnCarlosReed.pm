package DDG::Goodie::IsAwesome::JohnCarlosReed;
# ABSTRACT: JohnCarlosReed's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_john_carlos_reed";
zci is_cached   => 1;

triggers start => "duckduckhack johncarlosreed";

handle remainder => sub {
    return if $_;
    return "JohnCarlosReed is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
