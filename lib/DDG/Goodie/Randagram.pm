package DDG::Goodie::Randagram;
# ABSTRACT: Take a query and spit it out randomly.

use DDG::Goodie;
use List::Util 'shuffle';

triggers start => "randagram";

zci is_cached => 0;
zci answer_type => "randagram";

primary_example_queries "randagram jazz hands";
description "mix up the letters of your query";
name "Randagram";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Randagram.pm";
category "transformations";
topics "words_and_games";

attribution github => ["crazedpsyc", "Michael Smith"];

handle remainder => sub {
    s/^of\s(.*)/$1/i;
    my @chars = split(//, $_); #convert each character of the query to an array element
    my @garbledChars = shuffle(@chars); #randomly reorder the array
    my $garbledAnswer = join('',@garbledChars); #convert array to string
    return "Randagram of \"$_\": $garbledAnswer";
};

zci is_cached => 0;

1;
