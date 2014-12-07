package DDG::Goodie::IsAwesome::javathunderman;


use DDG::Goodie;

zci answer_type => "is_awesome:javathunderman";
zci is_cached   => 1;

name "IsAwesome:javathunderman";
description "You thought that this would be a good description, but really, it's subpar.";
primary_example_queries "duckduckhack javathunderman";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome:javathunderman.pm";
attribution github => ["javathunderman", "Thomas Denizou"],
            twitter => "Emposoft";


triggers start => "duckduckhack javathunderman";


handle remainder => sub {
    return if $_;
    return "javathunderman is awesome and has created a goodie!";
};

1;
