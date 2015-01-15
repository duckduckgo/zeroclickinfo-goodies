package DDG::Goodie::IsAwesome::amneher;
# ABSTRACT: amneher's first goodie


use DDG::Goodie;

zci answer_type => "is_awesome_amneher";
zci is_cached   => 1;


name "IsAwesome amneher";
description "Tells everyone that I'm awesome";
primary_example_queries "duckduckhack amneher";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/amneher.pm";
attribution github => ["amneher"],
            twitter => "amneher";


triggers start => "duckduckhack amneher";


handle remainder => sub {
    return if $_;
    return "amneher is awesome and has just completed the duckduckhack goodie tutorial!";
};

1;
