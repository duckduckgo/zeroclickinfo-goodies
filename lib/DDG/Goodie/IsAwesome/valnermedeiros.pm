package DDG::Goodie::IsAwesome::valnermedeiros;
# ABSTRACT: valnermedeiros's first Goodie

use DDG::Goodie;

zci answer_type => "is_awesome_valnermedeiros";
zci is_cached   => 1;

name "IsAwesome valnermedeiros";
description "Succinct explanation of what this instant answer does";
primary_example_queries "duckduckhack valnermedeiros";

category "special";

topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/valnermedeiros.pm";
attribution github => ["valnermedeiros", "Valner Medeiros"];

triggers start => "duckduckhack valnermedeiros";

handle remainder => sub {
	return if $_;
	return "ValnerMedeiros is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
