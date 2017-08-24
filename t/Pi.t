#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use utf8;

zci answer_type => "pi";
zci is_cached   => 1;

sub build_test {
    my ($answer, $input) = @_;
    return test_zci($answer, structured_answer => {
        data => {
            title => $answer,
            subtitle=> "First $input digits of Pi"
        },
        templates => {
            group => 'text'
        }
    })
}

ddg_goodie_test(
    [qw( DDG::Goodie::Pi )],

    'pi 23' => build_test("3.14159265358979323846264",23),
    'π 8' => build_test("3.14159265", 8),
    '12 digits of pi' => build_test("3.141592653589", 12),
    '12 digits of π' => build_test("3.141592653589", 12),
    'pi to 6 digits' => build_test("3.141592", 6),
    'π to 6 digits' => build_test("3.141592", 6),

    'pi ff' => undef,
    'pi 3f2' => undef,
    'pi 1001' => undef,
    'pi 1002' => undef,
);

done_testing;
