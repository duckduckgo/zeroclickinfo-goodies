package DDG::Goodie::IsAwesome::aseemraj;
# ABSTRACT: aseemraj's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_aseemraj";
zci is_cached   => 1;

name "IsAwesome aseemraj";
description "My first Goodie, it lets the world know that aseemraj is awesome";
primary_example_queries "duckduckhack aseemraj";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/aseemraj.pm";
attribution github => ["https://github.com/aseemraj", "aseemraj"],
            web => ['http://aseemraj.github.io', 'Aseem Raj'],
            twitter => "aseemrb";
            

triggers start => "duckduckhack aseemraj";

handle remainder => sub {
    return if $_;
    return "aseemraj is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
