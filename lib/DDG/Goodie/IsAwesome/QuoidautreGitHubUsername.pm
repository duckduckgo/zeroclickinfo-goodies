package DDG::Goodie::IsAwesome::QuoidautreGitHubUsername;
ABSTRACT: QuoidautreGitHubUsername''s first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_quoidautre_git_hub_username";
zci is_cached   => 1;

name "IsAwesome QuoiduGitHubUsername";
description "My first Goodie, it lets the world know that QuoidautreGitHubUsername is awesome";
primary_example_queries "duckduckhack QuoidautreGitHubUsername";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/QuoidautreGitHubUsername.pm";
attribution github => ["https://github.com/QuoidautreGitHubUsername", "QuoidautreGitHubUsername"],
            twitter => "quoidautre_test";

triggers start => "duckduckhack quoidautregithubusername";

handle remainder => sub {
    return if $_;
    return "QuoidautreGitHubUsername is awesome and has successfully completed the DuckDuckHack Goodie tutorial !!!!!";
};

1;
