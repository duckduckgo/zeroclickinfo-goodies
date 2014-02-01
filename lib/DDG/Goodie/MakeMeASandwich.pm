package DDG::Goodie::MakeMeASandwich;

use DDG::Goodie;

name 'Make Me A Sandwich';
source 'http://xkcd.com/149/';
description 'Responds in accordance to xkcd #149';
primary_example_queries 'make me a sandwich', 'sudo make me a sandwich';
category 'special';
topics 'geek';
code_url 'https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/MakeMeASandwich.pm';
attribution twitter => 'mattr555',
			github => ['mattr555', 'Matt Ramina'];

zci is_cached => 1;

triggers end => 'make me a sandwich';

handle remainder => sub {
	return 'Okay.', 
		html => 'Okay. <a href="http://xkcd.com/149/">XKCD</a>' if $_ eq 'sudo';
	return 'What? Make it yourself.', 
		html => 'What? Make it yourself. <a href="http://xkcd.com/149/">XKCD</a>' if not $_;
	return;
};

1;
