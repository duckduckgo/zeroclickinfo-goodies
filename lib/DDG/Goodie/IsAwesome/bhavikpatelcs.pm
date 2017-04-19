package DDG::Goodie::IsAwesome::bhavikpatelcs;
# ABSTRACT: GitHubUsername's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_bhavikpatelcs";
zci is_cached   => 1;

name "IsAwesome GitHubUsername";
description "My first Goodie, it let's the world know that bhavikpatelcs is awesome";
primary_example_queries "duckduckhack bhavikpatelcs";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/bhavikpatelcs.pm";
attribution github => ["https://github.com/bhavikpatelcs", "bhavikpatelcs"],
            twitter => "TwitterUserName";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers start => "duckduckhack bhavikpatelcs";

# Handle statement
handle remainder => sub {

    return "GitHubUsername is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
