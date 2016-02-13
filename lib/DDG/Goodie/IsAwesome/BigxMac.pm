package DDG::Goodie::IsAwesome::BigxMac;
# ABSTRACT: BigxMac's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_bigx_mac";
zci is_cached   => 1;

triggers start => "duckduckhack bigxmac";

handle remainder => sub {
    return if $_;
    return "BigxMac is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
