package DDG::Goodie::PrimeFactors;
# ABSTRACT: Returns all the prime factors of the entered number

use DDG::Goodie;

use Math::Prime::Util 'factor_exp', 'is_prime';

use bignum;
use utf8;

zci answer_type => "prime_factors";
zci is_cached => 1;

triggers startend => (
    'prime factors',
    'prime factors of',
    'the prime factors of',
    'factorization of',
    'prime factorization',
    'prime factorization of',
    'factorize',
    'prime factorize',
);

primary_example_queries 'prime factors of 30';
secondary_example_queries '72 prime factors', 'factorize 128';
description 'Returns the prime factors of the entered number';
name 'PrimeFactors';
topics 'math';
category 'calculations';
attribution github => [ 'https://github.com/austinheimark', 'austin_heimark' ];

# This adds exponents to the prime numbers.
# It outputs both text and HTML:
# - 2^2
# - 2<sup>2</sup>
sub format_exp {
    my $factor = shift;

    if($factor->[1] > 1) {
	return "$factor->[0]^$factor->[1]", "$factor->[0]<sup>$factor->[1]</sup>";
    }
    return $factor->[0], $factor->[0];
}

# This goes through all the prime factors and formats them in an "n × m" format.
# It outputs both text and HTML.
sub format_prime {
    my @factors = @_;
    my @text_result = ();
    my @html_result = ();

    foreach my $factor (@factors) {
	my ($text, $html) = format_exp($factor);
	
	push(@text_result, $text);
	push(@html_result, $html);
    }

    return join(" × ", @text_result), join(" × ", @html_result);
}

# This adds commas to the number.
# It converts 10000000 to 10,000,000.
# It was copied from http://perldoc.perl.org/perlfaq5.html#How-can-I-output-my-numbers-with-commas-added%3f
sub commify {
    no bignum;
    local $_  = shift;
    1 while s/^([-+]?\d+)(\d{3})/$1,$2/;
    return $_;
}

handle remainder => sub {
    # Exit if it's not a digit.
    # TODO: We should accept different number formats.
    return unless /^\d+$/;

    my $start_time = time();
    my @factors = ();
    
    # Provide only one second for computing the factors.
    eval {
	alarm(1);
	@factors = factor_exp($_);
    };
    # Exit if we didn't find anything.
    if(@factors == 0) {
	return;
    }

    my $formatted = commify($_);

    # If it has only one factor then it is a prime. Except if it's 0 or 1.
    my $result;
    if(is_prime($_)) {
	return "$formatted is a prime number.", html => "$formatted is a prime number.";
    } else {
	my ($text, $html) = format_prime(@factors);
	my $intro = "The prime factorization of $formatted is";

	return "$intro $text", html => "$intro $html";
    }
};

1;
