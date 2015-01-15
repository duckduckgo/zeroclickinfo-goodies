package DDG::Goodie::IsAwesome::watermelonwarrior;
# ABSTRACT: Watermelonwarrior's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_watermelonwarrior";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome watermelonwarrior";
description "My first Goodie, it let's the world konw that watermelonwarrior is awesome";
primary_example_queries "duckduckhack watermelonwarrior";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/watermelonwarrior.pm";
attribution github => ["https://github.com/watermelonwarrior", "Watermelonwarrior"],
            twitter => "harrisonson";

# Triggers
triggers start => "duckduckhack watermelonwarrior";

# Handle statement
handle remainder => sub {

    return if $_;
    return "Watermelonwarrior is awesome and has successfully completed the tutorial"
};

1;
