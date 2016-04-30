package DDG::Goodie::Luhn;
# ABSTRACT: Calculate check digit according to Luhn formula. 

use DDG::Goodie;
use strict;
use Algorithm::LUHN qw/check_digit /;

zci answer_type => 'luhn';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers startend => 'luhn';

# Handle statement
handle remainder => sub {

    return unless /^\s*\d+(?:(?:\s|,)+\d+)*\s*$/;
    
    my $tmp = $_ =~ s/\s//gr; # removing all white spaces

    my $result = check_digit($tmp);

    return "The Luhn check digit of $_ is $result.",
      structured_answer => {
        input     => [$_],
        operation => 'Luhn',
        result    => $result
      };
};

1;
