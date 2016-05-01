package DDG::Goodie::LeastCommonMultiple;
# ABSTRACT: Returns the least common multiple of the numbers entered

use DDG::Goodie;
use strict;

zci answer_type => 'least_common_multiple';
zci is_cached => 1;
triggers startend => 'lcm', 'lowest common multiple', 'least common multiple';

#greatest common factor helper function
sub gcf {
    my ($x, $y) = @_;
    ($x, $y) = ($y, $x % $y) while $y;
    return $x;
}
#least common multiple helper function
sub lcm {
    my $lcm = shift;
    foreach(@_) {
        $lcm = $lcm*$_/gcf($lcm, $_);
    }
    return $lcm;
}

handle remainder => sub {
    #return if there are no numbers
    return unless /\d/;
    
    #find and split the numbers in the remainder
    my @numbers = grep(/^\d/, split /\D+/);
    
    #format numbers for display
    my $formatted_numbers = join(', ', @numbers);
    $formatted_numbers =~ s/, ([^,]*)$/ and $1/;
    
    my $result = lcm(@numbers);
    
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
