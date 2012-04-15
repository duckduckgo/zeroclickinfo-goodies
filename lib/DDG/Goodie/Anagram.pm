package DDG::Goodie::Anagram;
# ABSTRACT: Take a query and spit it out randomly.

use DDG::Goodie;
use List::Util 'shuffle'; 

triggers start => "anagram";

handle remainder => sub {
  @chars = split(//, $_); #convert each character of the query to an array element
  @garbledChars = shuffle(@chars); #randomly reorder the array
  $garbledAnswer = join('',@garbledChars); #convert array to string
  return $garbledAnswer; 
};

zci is_cached => 0;

1;
  
  
