package DDG::Goodie::IsAwesome::CalaveraTheNine;
# ABSTRACT: CalaveraTheNine's first Goodie


use DDG::Goodie;

zci answer_type => "is_awesome_calavera_the_nine";
zci is_cached   => 1;


name "IsAwesome CalaveraTheNine";
description "My first Goodie, it let's the world know that GitHubUsername is awesome";
primary_example_queries "duckduckhack CalaveraTheNine";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/GitHubUsername.pm";
attribution github => ["https://github.com/GitHubUsername", "GitHubUserName"],
;
;


triggers start => "duckduckhack calaverathenine";


handle remainder => sub {
    return if $_;
    return "CalaveraTheNine is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
