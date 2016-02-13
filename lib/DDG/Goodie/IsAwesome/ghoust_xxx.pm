package DDG::Goodie::IsAwesome::ghoust_xxx;
# ABSTRACT: ghoust_xxx first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_ghoust_xxx";
zci is_cached   => 1;

triggers start => "duckduckhack ghoust_xxx";

handle remainder => sub {
    return if $_;
    return "ghoust_xxx is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
