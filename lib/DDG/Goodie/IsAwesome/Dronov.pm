package DDG::Goodie::IsAwesome::Dronov;
# ABSTRACT: Dronov's first Goodie
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "is_awesome_dronov";
zci is_cached   => 1;

name "Mikhail Dronov";
description "http://dronov.net";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
category "programming";
topics "geek", "programming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Dronov.pm";
attribution github => ["dronov", "Mikhail Dronov"],
            twitter => "dronovmm";

triggers start => "duckduckhack dronov";

handle remainder => sub {
    return if $_;
	return "Mikhail Dronov is awesome and has successfully completed the DuckDuckHack Goodie tutorial! He's saying hello from far cold Russia. Find him at dronov.net";
};

1;
