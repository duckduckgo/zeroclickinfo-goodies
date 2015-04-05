package DDG::Goodie::IsAwesome::GitHubrramyr;
# ABSTRACT: GitHubrramyr's first Goodie
# # Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "is_awesome_git_hubrramyr";
zci is_cached   => 1;

name "IsAwesome GitHubrramyr";
description "My first Goodie, it lets the world know that GitHubUsername is awesome";
primary_example_queries "duckduckhack GitHubrramyr";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/GitHubrramyr.pm";
attribution github => ["https://github.com/GitHubUsername", "GitHubrramyr"];
            
           
triggers any => "duckduckhack githubrramyr";

handle remainder => sub {
    return if $_;
    return "GitHubrramyr is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
