package DDG::Goodie::Luhn;
# ABSTRACT: Calculate check digit according to Luhn formula. 

use DDG::Goodie;
use strict;
use Algorithm::LUHN qw/check_digit /;
with 'DDG::GoodieRole::NumberStyler';

zci answer_type => 'luhn';

zci is_cached => 1;

triggers startend => 'luhn';

my $number_re = number_style_regex();
handle remainder => sub {

    return unless /^$number_re$/;
    
    my $tmp = $_ =~ s/\s//gr; # removing all white spaces

    my $result = check_digit($tmp);

    return $result,
        structured_answer => {
            data => {
                title => "$result",
                subtitle => "Luhn check digit for $_"
            },
            templates => {
                group => "text",
            }
        };
};

1;
