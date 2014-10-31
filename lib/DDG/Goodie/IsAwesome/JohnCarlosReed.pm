package DDG::Goodie::IsAwesome::JohnCarlosReed;
# ABSTRACT: JohnCarlosReed's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_john_carlos_reed";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome JohnCarlosReed";
description "My first Goodie, it let's the world know that JohnCarlosReed is awesome";
primary_example_queries "duckduckhack JohnCarlosReed";
#category "";
#topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/JohnCarlosReed/JohnCarlosReed.pm";
attribution github => ["https://github.com/JohnCarlosReed", "John Reed"],
            twitter => "johnnycarlos";

# Triggers
triggers start => "duckduckhack johncarlosreed";

# Handle statement
handle remainder => sub {
    return if $_;
    return "JohnCarlosReed is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
