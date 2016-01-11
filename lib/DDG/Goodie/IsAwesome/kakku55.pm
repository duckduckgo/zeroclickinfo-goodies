package DDG::Goodie::IsAwesome::kakku55;
# ABSTRACT: kakku55's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_kakku55";
zci is_cached   => 1;

triggers start => "duckduckhack kakku55";

handle remainder => sub {
    return if $_;
    return "kakku55 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
