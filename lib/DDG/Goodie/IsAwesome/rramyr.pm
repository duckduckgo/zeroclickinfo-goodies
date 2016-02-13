package DDG::Goodie::IsAwesome::rramyr;
# ABSTRACT: GitHubrramyr's first Goodie		

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_rramyr";
zci is_cached   => 1;

triggers any => "duckduckhack rramyr";

handle remainder => sub {
    return if $_;
    return "rramyr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
