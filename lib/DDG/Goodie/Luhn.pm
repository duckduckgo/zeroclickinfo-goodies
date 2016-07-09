package DDG::Goodie::Luhn;
# ABSTRACT: Calculate check digit according to Luhn formula. 

use DDG::Goodie;
use strict;
use Algorithm::LUHN qw/check_digit /;
with 'DDG::GoodieRole::NumberStyler';

zci answer_type => 'luhn';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers startend => 'luhn';

# Handle statement
handle remainder => sub {

    my $number_re = number_style_regex();
    return unless /^$number_re$/;
    
    my $tmp = $_ =~ s/\s//gr; # removing all white spaces

    my $result = check_digit($tmp);

    return $result,
        structured_answer => {
            data => {
                title => $result,
                subtitle => "The Luhn check digit of $_ is $result.",
            },
            templates => {
                group => "text",
            }
        };
};

1;
