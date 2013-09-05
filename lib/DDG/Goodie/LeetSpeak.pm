package DDG::Goodie::LeetSpeak;
# ABSTRACT: Translate the query into leet speak.

use DDG::Goodie;

triggers startend => 'leetspeak', 'l33tsp34k', 'l33t', 'leet speak', 'l33t sp34k';
primary_example_queries 'leetspeak hello world !';
description 'translates into leetspeak';
topics 'geek';
category 'conversions';
name 'LeetSpeak';

handle remainder => sub {
if(not $_) { return; };
my @alphabet = (
	'/-\\','|3','(','|)','3','|=','6','|-|','1','_|','|<','|_','|\/|','|\|','0','|D','(,)','|2','5',"']['",'|_|','\/','\^/','><',"`/",'2'
	);
my $res = "";

my $A = ord 'A';
my $Z = ord 'Z';

foreach my $letter (split //, uc $_)
{
	my $l = ord $letter;
	if ($l <= $Z and $l >= $A) { $res .= $alphabet[$l - $A]; }
	else { $res .= $letter; }
}

	return 'Leet Speak: ' . $res;
};

zci is_cached => 0;
1;
