package DDG::Goodie::IsAwesome::kefkius;
# ABSTRACT: kefkius' first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_kefkius";
zci is_cached   => 1;

triggers start => "duckduckhack kefkius";

handle remainder => sub {
    return if $_;
    return "kefkius is awesome, hello world!";
};

1;
