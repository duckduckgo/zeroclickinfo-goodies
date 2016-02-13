package DDG::Goodie::IsAwesome::jesuruban;
# ABSTRACT: Jesu Ruban's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_jesuruban";
zci is_cached   => 1;

triggers start => "duckduckhack jesuruban";

handle remainder => sub {
    return if $_;
    return "Jesu Ruban is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
