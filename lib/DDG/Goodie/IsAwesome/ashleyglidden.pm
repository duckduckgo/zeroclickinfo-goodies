package DDG::Goodie::IsAwesome::ashleyglidden;
# ABSTRACT: ashleyglidden's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ashleyglidden";
zci is_cached   => 1;

triggers start => "duckduckhack ashleyglidden";

handle remainder => sub {
    return if $_;
    return "ashleyglidden is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
