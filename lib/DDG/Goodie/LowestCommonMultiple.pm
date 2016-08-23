package DDG::Goodie::LowestCommonMultiple;
# ABSTRACT: Returns the Lowest Common Multiple of the two numbers entered

use strict;
use DDG::Goodie;
use Math::BigInt try => 'GMP';

zci answer_type => "lowest_common_multiple";
zci is_cached   => 1;

triggers startend => 'lcm','lowest common multiple';

handle remainder => sub {

    return unless /^\s*\d+(?:(?:\s|,)+\d+)*\s*$/;

    # Here, $_ is a string of digits separated by whitespaces. And $_
    # holds at least one number.

    my @numbers = grep(/^\d/, split /(?:\s|,)+/);
    return unless @numbers > 1;
  
    @numbers = sort { $a <=> $b } @numbers;
        
    my $formatted_numbers = join(', ', @numbers);
    $formatted_numbers =~ s/, ([^,]*)$/ and $1/;

    my $result = $numbers[0] * $numbers[1] / Math::BigInt::bgcd(@numbers);

    return "Lowest Common Multiple of $formatted_numbers is $result.",
     structured_answer => {
	  data => {
	   title => "$result",
	   subtitle => "Lowest Common Multiple: $formatted_numbers"
	 },
     templates => {
       group => "text",
    }
  };
};

1;
