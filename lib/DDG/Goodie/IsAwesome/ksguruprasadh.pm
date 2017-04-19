package DDG::Goodie::IsAwesome::ksguruprasadh;
# ABSTRACT: Goodie by ksguruprasadh

use DDG::Goodie;

zci answer_type => "is_awesome_ksguruprasadh";
zci is_cached   => 1;


name "IsAwesome ksguruprasadh";
description "DuckDuckHack Goodie";
primary_example_queries "guruprasadh";
secondary_example_queries "optional -- demonstrate any additional triggers";

category "special";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ksguruprasadh.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";


triggers start => "guruprasadh";

handle remainder => sub {

    return if $_;
    return "K.S.Guruprasadh, tech lover, will answer you in DuckDuckGo.";

};

1;
