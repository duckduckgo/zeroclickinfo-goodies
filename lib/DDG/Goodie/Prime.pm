package DDG::Goodie::Prime;
# ABSTRACT: Will return whether a number is prime, and return its factors if not.

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'prime';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers startend => 'is prime', 'prime';

# Handle statement
handle remainder => sub {

    my $remainder = $_;
    print $remainder;

    # Optional - Guard against no remainder
    # I.E. the query is only 'triggerWord' or 'trigger phrase'
    #
    return unless $remainder;

    # Optional - Regular expression guard
    # Use this approach to ensure the remainder matches a pattern
    # I.E. it only contains letters, or numbers, or contains certain words
    #
    # return unless /^\s*\d+\s*$/;
    $remainder =~ s/[^0-9]//g;
    print $remainder;
    
    my $result = "prime";
    my $title = "Prime";
    my @factors = ();
    my $description = "$remainder is only divisible by itself and 1";
    
    for( $a = 2; $a <= $remainder / 2; $a = $a + 1 ){
        if($remainder % $a == 0) {
            $result = "composite";
            $title = "Composite";
            push @factors, $a;
        }
    }

    if($result eq "composite") {
        $description = "$remainder is divisible by @factors"
    }

    return "$remainder is a $result number",
      structured_answer => {
        data => {
            title => $title,
            subtitle => $description
        },
        templates => {
            group => "text"
        }
      };
};

1;
