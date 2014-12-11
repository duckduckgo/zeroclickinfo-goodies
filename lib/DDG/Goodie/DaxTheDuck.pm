package DDG::Goodie::DaxTheDuck;


use DDG::Goodie;

zci answer_type => "dax_the_duck";
zci is_cached   => 1;


name "Dax the Duck";
description "When you type in Dax the Duck, it tells you where Dax is. ";
primary_example_queries "Dax the Duck";
category "special";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DaxTheDuck.pm";
attribution github => ["javathunderman", "Thomas Denizou"],
            twitter => "Emposoft";


triggers any => "dax the duck";


handle remainder => sub {


	return "You know, I am on the front page!";

	return $_;
};

1;
