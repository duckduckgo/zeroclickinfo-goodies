package DDG::Goodie::IsAwesome::Bitflipped;

use DDG::Goodie;

zci answer_type             => "is_awesome_bitflipped";
zci is_cached               => 1;


name                        "IsAwesome Bitflipped";
description                 "Prints nice message";
primary_example_queries     "duckduckhack bitflipped";
secondary_example_queries   "optional -- demonstrate any additional triggers";
category                    "special";
topics                      "special_interest", "geek";
code_url                    "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Bitflipped.pm";
attribution github          => ["bitflipped", "Jon A"];



triggers start      => "duckduckhack bitflipped";


handle remainder    => sub {

	return if $_; # Guard against "no answer"

	return "bitflipped is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
