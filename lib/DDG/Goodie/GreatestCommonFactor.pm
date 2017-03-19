package DDG::Goodie::GreatestCommonFactor;
# ABSTRACT: Returns the greatest common factor of the two numbers entered

use strict;
use DDG::Goodie;
use Math::BigInt try => 'GMP';

zci answer_type => "greatest_common_factor";
zci is_cached   => 1;

triggers startend => 'greatest common factor', 'gcf', 'greatest common divisor', 'gcd';

handle remainder => sub {

    return unless /^\s*\d+(?:(?:\s|,)+\d+)*\s*$/;

    # Here, $_ is a string of digits separated by whitespaces. And $_
    # holds at least one number.

    my @numbers = grep(/^\d/, split /(?:\s|,)+/);
    return unless @numbers > 1;
  
    @numbers = sort { $a <=> $b } @numbers;
        
    my $formatted_numbers = join(', ', @numbers);
    $formatted_numbers =~ s/, ([^,]*)$/ and $1/;

    my $result = Math::BigInt::bgcd(@numbers);

    return "Greatest common factor of $formatted_numbers is $result",
     structured_answer => {
	  data => {
	   title => "$result",
	   subtitle => "Greatest common factor: $formatted_numbers"
	 },
     templates => {
       group => "text",
    }
  };
};

1;
