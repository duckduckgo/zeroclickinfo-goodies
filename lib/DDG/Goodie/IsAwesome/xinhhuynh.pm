package DDG::Goodie::IsAwesome::xinhhuynh;
# ABSTRACT: xinhhuynh's first goodie.

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_xinhhuynh";
zci is_cached   => 1;

triggers start => "duckduckhack xinhhuynh";

handle remainder => sub {

    return if $_;
    return "xinhhuynh is awesome and has successfully completed the tutorial!"; # Guard against "no answer"
};

1;
