package DDG::Goodie::IsAwesome::kfloey;
# ABSTRACT: kfloey's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_kfloey";
zci is_cached   => 1;

triggers start => "duckduckhack kfloey";


handle remainder => sub {
    return if $_;
    return "kfloey is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
