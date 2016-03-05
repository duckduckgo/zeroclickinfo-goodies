package DDG::Goodie::PrimeFactors;
# ABSTRACT: Returns all the prime factors of the entered number

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';

use Math::Prime::Util 'factor_exp', 'is_prime';

use utf8;

zci answer_type => "prime_factors";
zci is_cached => 1;

use bignum;

triggers any => (
    'prime factors',
    'factorization',
    'factorize',
);
my $matcher = wi_custom(
    groups => ['property', 'command'],
    options => {
        command => qr/(prime )?factor(iz(e|ation)|s)/i,
        property => qr/(prime )?factor(ization|s)/i,
        # TODO: We should accept different number formats.
        primary => qr/\d+/,
    },
);

sub convert_to_superscripts (_) {
    my $string = $_[0];
    $string =~ tr[+−=()0123456789]
                [⁺⁻⁼⁽⁾⁰¹²³⁴⁵⁶⁷⁸⁹ⵯ];
    return $string;
}

# This adds exponents to the prime numbers.
# It outputs both plaintext and the number that will be displayed:
# - 2^2
# - 2²
sub format_exp {
    my $factor = shift;

    if($factor->[1] > 1) {
        return "$factor->[0]^$factor->[1]", "$factor->[0]".convert_to_superscripts($factor->[1]);
    }
    return $factor->[0], $factor->[0];
}

# This goes through all the prime factors and formats them in an "n × m" format.
# It outputs both plaintext and the text that will be used in the answer.
sub format_prime {
    my @factors = @_;
    my @text_result = ();
    my @answer_result = ();

    foreach my $factor (@factors) {
        my ($text, $exp) = format_exp($factor);

        push(@text_result, $text);
        push(@answer_result, $exp);
    }

    return join(" × ", @text_result), join(" × ", @answer_result);
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

# Structured answer that will be returned
sub format_answer {
    my ($plaintext, $title, $subtitle) = @_;

    return $plaintext,
    structured_answer => {
        data => {
            title => $title || $plaintext,
            subtitle => $subtitle
        },
        templates => {
            group => 'text'
        }
    };
}

handle query => sub {
    my $query = shift;
    my $match = $matcher->full_match($query) or return;

    my $start_time = time();
    my @factors = ();

    # Provide only one second for computing the factors.
    my $to_factorize = $match->{primary};
    eval {
        alarm(1);
        @factors = factor_exp($to_factorize);
    };
    # Exit if we didn't find anything.
    if(@factors == 0) {
        return;
    }

    my $formatted = commify($to_factorize);

    # If it has only one factor then it is a prime. Except if it's 0 or 1.
    my @result;
    if(is_prime($to_factorize)) {
        @result = format_answer("$formatted is a prime number");
    } else {
        my ($text, $answer) = format_prime(@factors);
        my $subtitle = "$formatted - Prime Factors";
        my $plaintext = "The prime factorization of $formatted is $text";

        @result = format_answer($plaintext, $answer, $subtitle);
    }

    return @result;
};

1;
