package DDG::Goodie::IsAwesome::murz;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "is_awesome_murz";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome murz";
description "My first Goodie, it lets the world know that murz is awesome";
primary_example_queries "duckduckhack murz";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/murz.pm";
attribution github => ["GitHubAccount", "murz"];

# Triggers
triggers start => "duckduckhack murz";

# Handle statement
handle remainder => sub {
    return if $_;
    return "murz is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
