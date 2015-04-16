package DDG::Goodie::IsAwesome::QuoidautreGitHubUsername;
#ABSTRACT: QuoidautreGitHubUsername's first Goodie;

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_git_hub_username";
zci is_cached   => 1;

name "IsAwesome QuoidautreGitHubUsername";
description "My first Goodie, it lets QuoidautreGitHubUsername";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/GitHubUsername.pm";
attribution github => ["https://github.com/quoidautre", "quoidautre"],
            twitter => "quoidautre_test";

triggers start => "duckduckhack quoidautregithubusername";

handle remainder => sub {
    return if $_;
    return "QuoidautreGitHubUsername is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
