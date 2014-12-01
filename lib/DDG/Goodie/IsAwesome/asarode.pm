package DDG::Goodie::IsAwesome::asarode;
# ABSTRACT: asarode's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_asarode";
zci is_cached   => 1;

name "IsAwesome asarode";
description "My first Goodie, it let's the world know that asarode is awesome";
primary_example_queries "duckduckhack asarode";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/asarode.pm";
attribution github => ["https://github.com/asarode", "Arjun Sarode"],
            twitter => "rjun07a",
            web => "http://asarode.github.io/";

triggers start => "duckduckhack asarode";

handle remainder => sub {
    return if $_;
    return "asarode is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
