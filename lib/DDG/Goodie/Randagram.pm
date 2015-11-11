package DDG::Goodie::Randagram;
# ABSTRACT: Take a query and spit it out randomly.

use strict;
use DDG::Goodie;
use List::Util 'shuffle';

triggers start => "randagram";

zci is_cached => 0;
zci answer_type => "randagram";

handle remainder => sub {
    s/^of\s(.*)/$1/i;
    my @chars = split(//, $_); #convert each character of the query to an array element
    my @garbledChars = shuffle(@chars); #randomly reorder the array
    my $garbledAnswer = join('',@garbledChars); #convert array to string
    return "Randagram of \"$_\": $garbledAnswer";
};

zci is_cached => 0;

1;
