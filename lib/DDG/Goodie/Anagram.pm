package DDG::Goodie::Anagram;
# ABSTRACT: Take a query and spit it out randomly.

use DDG::Goodie;
use List::Util 'shuffle'; 

triggers start => "randagram";

handle remainder => sub {
  my @chars = split(//, $_); #convert each character of the query to an array element
  my @garbledChars = shuffle(@chars); #randomly reorder the array
  my $garbledAnswer = join('',@garbledChars); #convert array to string
  return $garbledAnswer; 
};

zci is_cached => 0;

1;
