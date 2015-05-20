package DDG::Goodie::Binomial;
# ABSTRACT: Calculates binomial coefficients

use DDG::Goodie;
use List::Util qw/ product /;
use strict;

zci answer_type => "binomial";
zci is_cached   => 1;

name "Binomial";
description "Computes Binomial coefficients";
primary_example_queries "binomial(7, 1)", "7 choose 1";
category "calculations";
topics "math";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Binomial.pm";
attribution github => ["MichaelBurge", "Michael Burge"];
            github => ["javathunderman", "Thomas Denizou"];

my $choose_regex = qr/(\d+) choose (\d+)/i;
my $binomial_regex = qr/binomial\((\d+),\s*(\d+)\)/i;

triggers query_raw => $choose_regex, $binomial_regex;

my $maximum_size = 10000; # Don't let people create a billion element temporary list

sub compute_binomial {
    my ($n, $k) = @_;
    return 1 if $k == 0 || $k == $n;
    return undef if $n > $maximum_size || $k > $maximum_size;
    return product( map { ($n + 1 - $_) / $_ } (1..$k) );
}

sub binomial_response {
    my ($n, $k) = @_;
    my $result = compute_binomial($n, $k);
    return undef unless defined($result);
    return "binomial($n, $k) = $result"
}

handle query_raw => sub {
    my ($query) = @_;

    return binomial_response($1, $2) if $query =~ $choose_regex;
    return binomial_response($1, $2) if $query =~ $binomial_regex;
};

1;
