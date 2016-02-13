package DDG::Goodie::IsAwesome::abrahimladha;
# ABSTRACT: abrahimladha's first Goodie


use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_abrahimladha";
zci is_cached   => 1;

triggers start => "duckduckhack abrahimladha";

handle remainder => sub {
    return if $_;
    return "abrahimladha is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
