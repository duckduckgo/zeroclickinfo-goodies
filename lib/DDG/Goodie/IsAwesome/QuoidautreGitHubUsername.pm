package DDG::Goodie::IsAwesome::QuoidautreGitHubUsername;
#ABSTRACT: QuoidautreGitHubUsername first Goodie;

use DDG::Goodie;

zci answer_type => "is_awesome_git_hub_username";
zci is_cached   => 1;

name "IsAwesome QuoidautreGitHubUsername";
description "Succinct explanation of what this Instant Answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/GitHubUsername.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

#triggers start => "duckduckhack quoidautregithubusername";
triggers start => "duckduckhack quoidautregithubusername";

handle remainder => sub {
    return if $_;
    return "QuoidautreGitHubUsername is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
