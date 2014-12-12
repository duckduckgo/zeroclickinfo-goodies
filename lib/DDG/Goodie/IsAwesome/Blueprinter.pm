package DDG::Goodie::IsAwesome::Blueprinter;
# ABSTRACT: Blueprinter's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_blueprinter";
zci is_cached   => 1;

name "IsAwesome Blueprinter";
description "My first Goodie, it let's the world know that GitHubUsername is awesome";
primary_example_queries "duckduckhack Blueprinter";
category "special";
topics "special_interest", "geek";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Blueprinter.pm";

attribution github => ["https://github.com/Blueprinter", "Blueprinter"];
           
triggers start => "duckduckhack blueprinter";

handle remainder => sub {
    return if $_;
    return "Blueprinter is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
