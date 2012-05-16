package DDG::Goodie::Primes;
# Generates the prime numbers between 1 and a number, unless that number is greater than a million.

use DDG::Goodie;
use Math::Prime::TiedArray;
my @primes;



triggers start => 'prime';


zci answer_type => "prime numbers";


handle remainder => sub {
    if ($_ <= 1000000) {
        tie @primes, "Math::Prime::TiedArray", precompute => $_;
    }
    else {
        return "Number is too big.";
    }
    if (($_ =~ /(\d+)/) && ($_ <= 1000000)) {
        
        while ((my $prime = shift @primes) < $_) {
            return "@primes";

        }
      
    }
    else {
        return;
    } 
   
};

1;

