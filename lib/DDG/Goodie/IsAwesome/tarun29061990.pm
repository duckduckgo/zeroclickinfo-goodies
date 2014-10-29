package DDG::Goodie::IsAwesome::tarun29061990;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "is_awesome_tarun29061990";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome tarun29061990";
description "My first Goodie, it let's the world know that tarun29061990 is awesome";
primary_example_queries "duckduckhack tarun29061990";
category "";
topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/tarun29061990.pm";
attribution github => ["https://github.com/tarun29061990", "tarun29061990"],
            twitter => "_tarunChaudhary";

# Triggers
triggers start => "duckduckhack tarun29061990";

# Handle statement
handle remainder => sub {
    return if $_;
    return "tarun29061990 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
