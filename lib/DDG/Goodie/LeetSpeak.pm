package DDG::Goodie::LeetSpeak;
# ABSTRACT: Translate the query into leet speak.

use DDG::Goodie;

triggers startend => 'leetspeak', 'l33tsp34k', 'l33t', 'leet speak', 'l33t sp34k';
primary_example_queries 'leetspeak hello world !';
description 'translates into leetspeak';
topics 'geek';
category 'conversions';
name 'LeetSpeak';
code_url 'https://github.com/antoine-vugliano/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/LeetSpeak.pm';
attribution github => ['https://github.com/antoine-vugliano', 'antoine-vugliano'],
	web => ['http://antoine.vugliano.free.fr', 'Antoine Vugliano'];

my @alphabet = (
	'/-\\','|3','(','|)','3','|=','6','|-|','1','_|','|<','|_','|\/|','|\|','0','|D','(,)','|2','5',"']['",'|_|','\/','\^/','><',"`/",'2'
	);

handle remainder => sub {
	if(not $_) { return; }

	my $res = "";
	my $l = 0;

	my $A = ord 'A';
	my $Z = ord 'Z';

	foreach my $letter (split //, uc $_)
	{
		$l = ord $letter;
		if ($l ~~ [$A..$Z]) { $res .= $alphabet[$l - $A]; }
		else { $res .= $letter; }
	}

	return "Leet Speak: $res";
};

zci is_cached => 1;
1;
