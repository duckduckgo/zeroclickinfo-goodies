package DDG::Goodie::IsAwesome::asarode;
# ABSTRACT: asarode's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_asarode";
zci is_cached   => 1;

triggers start => "duckduckhack asarode";

handle remainder => sub {
    return if $_;
    return "asarode is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
