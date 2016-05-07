package DDG::Goodie::LeastCommonMultiple;
# ABSTRACT: Returns the least common multiple of the numbers entered

use DDG::Goodie;
use Math::BigInt;
use strict;

with 'DDG::GoodieRole::NumberStyler';

zci answer_type => 'least_common_multiple';
zci is_cached => 1;
triggers startend => 'lcm', 'lowest common multiple', 'least common multiple';

handle remainder => sub {
    my $remainder = $_;
    #return if there are no numbers
    return unless /\d/;
    
    #find and split the numbers in the remainder
    my $number_re = DDG::GoodieRole::NumberStyler::number_style_regex();
    my @numbers = grep(/$number_re/, split(/[^\d,\.]+|,(?!\d{3})/, $remainder));
    my $styler = number_style_for(@numbers);
    return unless $styler && @numbers > 1;  #ensure numbers are a supported format and there's more than one number
    
    #format for computations
    foreach(@numbers) {
        $_ = $styler->for_computation($_);
    }
    
    #return if there are any decimals
    for(my $i = 0; $i < @numbers; $i++) {
        if ($numbers[$i] =~ m/\./) {
            return;
        }
    }
    
    my $result = Math::BigInt::blcm(@numbers)->bstr();
    
    #format numbers for display
    grep($_=$styler->for_display($_), @numbers);
    my $formatted_numbers = join(', ', @numbers[0..$#numbers-1]) . " and $numbers[$#numbers]";
    
    return "Least common multiple of $formatted_numbers is $result.",
        structured_answer => {
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
