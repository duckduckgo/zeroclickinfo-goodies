package DDG::Goodie::LeastCommonMultiple;
# ABSTRACT: Returns the least common multiple of the numbers entered

use DDG::Goodie;
use Math::BigInt;
use strict;

zci answer_type => 'least_common_multiple';
zci is_cached => 1;
triggers startend => 'lcm', 'lowest common multiple', 'least common multiple';

handle remainder => sub {
    #return if there are no numbers
    return unless /\d/;
    
    #find and split the numbers in the remainder
    my @numbers = grep(/^\d/, split /\D+/);
    
    #format numbers for display
    my $formatted_numbers = join(', ', @numbers);
    $formatted_numbers =~ s/, ([^,]*)$/ and $1/;
    
    my $result = Math::BigInt::blcm(@numbers);
    
    return "Least common multiple of $formatted_numbers is $result.",
        structured_answer => {
            input => [$formatted_numbers],
            operation => 'Least common multiple',
            result => $result,
            name => 'Math',
            id=>'least_common_multiple',
            
            data => {
                title => $result,
                subtitle => "Least common multiple of $formatted_numbers",
            },
            templates => {
                group => "text"
            }
        };
};
1;
