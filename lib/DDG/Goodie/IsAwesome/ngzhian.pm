package DDG::Goodie::IsAwesome::ngzhian;
# ABSTRACT: ngzhian's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ngzhian";
zci is_cached   => 1;

triggers start => "duckduckhack ngzhian";

handle remainder => sub {
    return if $_;
    return "ngzhian is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
