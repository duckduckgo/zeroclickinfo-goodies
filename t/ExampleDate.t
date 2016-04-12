#!/usr/bin/env perl

use strict;
use warnings;
use Test::Deep;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "example_date";
zci is_cached   => 0;

sub build_structured_answer {
    my ($format, $result) = @_;
    return $result,
        structured_answer => {

            data => {
              title => $result,
              subtitle => "Random date for: $format",
            },

            templates => {
                group => "text",
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

my $time_24 = qr/\d{2}:\d{2}:\d{2}/;
my $time_12 = qr/\d{1,2}:\d{2}:\d{2} [AP]M/;
my $short_name = qr/[A-Z][a-z]{2}/;
my $long_name = qr/[A-Z][a-z]{2,}/;
my $week = qr/\d{2}/;

ddg_goodie_test(
    [qw( DDG::Goodie::ExampleDate )],
    'random date for %Y'  => build_test('%Y', re(qr/\d{4}/)),
    'date for %a, %b %T'  => build_test('%a, %b %T', re(qr/$short_name, $short_name $time_24/)),
    'example date for %a' => build_test('%a', re(qr/$short_name/)),
    # 'Standard' Queries
    'random weekday' => build_test('%A', re($long_name)),
    'random month'   => build_test('%B', re($long_name)),
    'random time'    => build_test('%X', re($time_12)),
    'random week'    => build_test('%W', re($week)),
    # Invalid Queries
    'date for %K'   => undef,
    'random number' => undef,
    'example date'  => undef,
);

done_testing;
