package DDG::Goodie::IsAwesome::zekiel;
# ABSTRACT: A simple goodie by zekiel

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_zekiel";
zci is_cached   => 1;

triggers start => "duckduckhack zekiel", "zekiel duckduckhack";

handle remainder => sub {
    return if $_;
    return "zekiel is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
