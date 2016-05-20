#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'reverse';
zci is_cached   => 1;

sub build_test {
    my ($input, $answer) = @_;
    return test_zci(qq|Reversed "$input": $answer|, structured_answer => {
        data => {
            title => $answer,
            subtitle => "Reverse string: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Reverse )],
    # Primary example query
    'reverse text esrever' => build_test('esrever', 'reverse'),
    # Other queries
    'reverse text bla' => build_test('bla', 'alb'),
    'reverse text blabla' => build_test('blabla', 'albalb'),
    'reverse' => undef,

    #Should not trigger on a request for DNA/RNA reverse complement
    'reverse complement of ATG-CTA-GGG-GCT'     => undef,
    'reverse complement gacuacgaucgagkmanscuag' => undef
);

done_testing;
