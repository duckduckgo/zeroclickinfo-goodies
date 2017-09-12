#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "name_days";
zci is_cached   => 1;

sub build_country {
    my($country, $flag, $months) = @_;
    return {
               country => $country,
               flag    => $flag,
               months  => $months
           }
}

sub build_answer {
    my($string_answer, $name, $name_days) = @_;
    return $string_answer,
        structured_answer => {
            data => {
                name      => $name,
                name_days => $name_days
            },
            templates => {
                group => 'text'
            }
        }
}

sub build_test { test_zci(build_answer(@_)) }

my @philip_days = ();
push @philip_days, build_country('Denmark', 'dk', ['May 1']);

ddg_goodie_test(
    [qw(
        DDG::Goodie::Palindrome
    )],
    'philip name days' => build_test('Denmark: 1 May;', 'Philip', \@philip_days),
);

done_testing;
