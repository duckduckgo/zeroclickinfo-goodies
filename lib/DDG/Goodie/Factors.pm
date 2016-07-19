package DDG::Goodie::Factors;
# ABSTRACT: Returns the factors of the entered number

use strict;
use DDG::Goodie;

use Math::Prime::Util 'divisors';

zci answer_type => "factors";
zci is_cached   => 1;

triggers startend => 'factors', 'factors of';

handle remainder => sub {
    my $query = $_;
    return unless $query =~ /^\d+$/;

    my $factors = join ', ', divisors($query);

    return "Factors of $query: $factors", structured_answer => {
        data => {
            title => $factors,
            subtitle => "Factors of: $query"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
