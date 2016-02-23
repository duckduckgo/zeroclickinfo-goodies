package DDG::Goodie::IsAwesome::Blueprinter;
# ABSTRACT: Blueprinter's first Goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_blueprinter";
zci is_cached   => 1;

triggers start => "duckduckhack blueprinter";

handle remainder => sub {
    return if $_;
    return "Blueprinter is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
