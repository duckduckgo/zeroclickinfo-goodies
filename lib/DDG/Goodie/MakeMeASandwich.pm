package DDG::Goodie::MakeMeASandwich;
# ABSTRACT: XKCD #149 Easter Egg

use DDG::Goodie;

name 'Make Me A Sandwich';
source 'http://xkcd.com/149/';
description 'Responds in accordance with xkcd #149';
primary_example_queries 'make me a sandwich', 'sudo make me a sandwich';
category 'special';
topics 'geek';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MakeMeASandwich.pm';
attribution twitter => 'mattr555',
            github => ['https://github.com/mattr555/', 'Matt Ramina'];

triggers end => 'make me a sandwich';

handle remainder => sub {
    return 'Okay.', 
        html => 'Okay. <br><a href="http://xkcd.com/149/">More at xkcd</a>' if $_ eq 'sudo';
    return 'What? Make it yourself.', 
        html => 'What? Make it yourself. <br><a href="http://xkcd.com/149/">More at xkcd</a>' if $_ eq '';
    return;
};

1;
