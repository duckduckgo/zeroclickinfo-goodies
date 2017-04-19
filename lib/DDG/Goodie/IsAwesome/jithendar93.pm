package DDG::Goodie::IsAwesome::jithendar93;
# ABSTRACT: jithendar93's first Goodie


use DDG::Goodie;

zci answer_type => "is_awesome_jithendar93";
zci is_cached   => 1;

name "IsAwesome jithendar93";
description "My first Goodie, it let's the world know that jithendar93 is awesome";
primary_example_queries "duckduckhack jithendar93";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jithendar93.pm";
attribution github => ["https://github.com/jithendar93", "jithendar93"],
#            twitter => "TwitterUserName";

# Triggers
triggers start => "duckduckhack jithendar93";

# Handle statement
handle remainder => sub {
    return if $_;
	return "jithendar93 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
    
};

1;
