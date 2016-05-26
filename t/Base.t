#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'conversion';
zci is_cached   => 1;

sub build_structured_answer {
    my ($number, $base, $based) = @_;
    return "$number in base $base is $based",
        structured_answer => {
            data => {
                title    => $based,
                subtitle => "Decimal to base $base: $number"
            },
            templates => {
                group => 'text'
            }
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw(DDG::Goodie::Base)],

    '255 in hex'     => build_test(255, 16, 'FF'),
    '255 in base 16' => build_test(255, 16, 'FF'),
    '42 in binary'   => build_test(42, 2, '101010'),
    '42 in base 2'   => build_test(42, 2, '101010'),
    '42 to hex'      => build_test(42, 16, '2A'),
    '42 to octal'    => build_test(42, 8, '52'),
    '10 in base 3'   => build_test(10, 3, '101'),
    '18442240474082181119 to hex'     => build_test(18442240474082181119, 16, 'FFEFFFFFFFFFFFFF'),
    '999999999999999999999999 to hex' => build_test("999999999999999999999999", 16, 'D3C21BCECCEDA0FFFFFF'),
);

done_testing;
