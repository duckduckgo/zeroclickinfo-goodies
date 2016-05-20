#!/usr/bin/env perl

use strict;
use warnings;
use Test::Deep;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "shuffle";
zci is_cached   => 0;

sub build_structured_answer {
    my $items = shift;
    my @items = @$items;
    my $show = "[@{[join ', ', @items]}]";
    return "$show",
        structured_answer => {

            data => {
                title    => re(qr/^\[.+?\]$/),
                items    => bag(@items),
                subtitle => "Shuffle: $show",
            },

            templates => {
                group => "text",
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::Shuffle )],
    # Different types of brackets
    'shuffle [1, 2]' => build_test([1, 2]),
    'shuffle (1, 2)' => build_test([1, 2]),
    'shuffle {1, 2}' => build_test([1, 2]),
    # Trailing form
    '[1, 2] shuffled' => build_test([1, 2]),
    # Nothing to shuffle
    'shuffle []'  => undef,
    'shuffle [1]' => undef,
    'shuffle'     => undef,
);

done_testing;
