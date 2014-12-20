package DDG::Goodie::IsAwesome::ecelis;
# ABSTRACT: ecelis first goodie

use DDG::Goodie;

zci answer_type => "is_awesome_ecelis";
zci is_cached   => 1;

name "IsAwesome ecelis";
description "First thing is to be listed in DDG somehow ;)";
primary_example_queries "duckduckhack ecelis;
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ecelis.pm";
attribution github => ["https://github.com/ecelis", "ecelis"],
            twitter => "celisdelafuente",
            web => ["http://ernesto.celisdelafuente.net", "Ernesto Celis"];

# Triggers
triggers start => "duckduckhack ecelis";

# Handle statement
handle remainder => sub {
    return if $_;
	return "ecelis has completed the DuckDuckGoHack goodie tutorial!";
};

1;
