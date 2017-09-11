package DDG::Goodie::SumOfNaturalNumbers;
# ABSTRACT: Returns the sum of the numbers between the first and second provided integers

use strict;
use DDG::Goodie;

triggers start => "add", "sum from";
triggers startend => "sum";

zci is_cached => 1;
zci answer_type => "sum";

use bignum;

# This adds commas to the number.
# It converts 10000000 to 10,000,000.
# It was copied from http://perldoc.perl.org/perlfaq5.html#How-can-I-output-my-numbers-with-commas-added%3f
sub commify {
    # Disable bigint in this function. It interferes with `1 while ...`.
    no bigint;
    local $_  = shift;
    1 while s/^([-+]?\d+)(\d{3})/$1,$2/;
    return $_;
}

handle remainder => sub {
    # Check if we're getting integers.
    return unless $_ =~ /^(?:from )?(\d+)\s*(to|-)\s*(\d+)$/i;

    return if ($1 > $3);

    my $sum = commify((($3 * ($3 + 1)) / 2)-(($1 * ($1 - 1)) / 2));
    my ($from_number, $to_number) = map { commify($_) } ($1, $3);
    my $string_answer = 'Sum of natural numbers from ' . $from_number . ' to ' . $to_number;
    return $string_answer, structured_answer => {
        data => {
            title => "$sum",
            subtitle => $string_answer
        },
        templates => {
            group => 'text'
        }
    }
};

1;
