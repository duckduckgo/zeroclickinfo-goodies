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

    return unless $query =~ /^(-)?(\d+)$/;

    # The divisors method cannot handle negative numbers, so find the
    # query magnitude and call it with that instead. Then if the
    # query number is negative, find and include negative factors.
    my $negative  = $1;
    my $query_mag = $2;
    my @factors   = divisors($query_mag);

    unshift @factors, sort { $a <=> $b } map { -$_ } @factors
        if $negative;

    my $factors_list = join ', ', @factors;

    return "Factors of $query: $factors_list", structured_answer => {
        data => {
            title    => $factors_list,
            subtitle => "Factors of: $query"
        },
        templates => { group => 'text' }
    };
};

1;
