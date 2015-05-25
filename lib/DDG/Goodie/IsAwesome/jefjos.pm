package DDG::Goodie::IsAwesome::jefjos;
ABSTRACT: jefjos's first goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_jefjos";
zci is_cached   => 1;

name "IsAwesome jefjos";
description "My first Goodie, it lets the world know that jefjos is awesome";
primary_example_queries "duckduckhack jefjos";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jefjos.pm";
attribution github => ["https://github.com/jefjos", "jefjos"];

triggers start => "duckduckhack jefjos";

handle remainder => sub {

    # optional - regex guard
    # return unless qr/^\w+/;
    return if $_;
    return "Jefjos is awesome!";
};

1;
