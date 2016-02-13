package DDG::Goodie::IsAwesome::rohit;
# ABSTRACT: A simple goodie by rohit

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_rohit";
zci is_cached   => 1;

triggers start => "duckduckhack rohit", "rohit duckduckhack";

handle remainder => sub {
    return if $_;
    return "rohit is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
