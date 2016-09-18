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

my @all = (
    'random order',
    'random shuffle',
    'random sort',
);
my @starts = (
    @all,
    'randomly order',
    'randomly shuffle',
    'randomly sort',
    'shuffle',
);

my @ends = (
    @all,
    'in a random order',
    'randomly ordered',
    'randomly shuffled',
    'randomly sorted',
    'shuffled',
);

my @triggers = map { $_ => build_test([1, 2]) } (
    (map { "$_ [1, 2]" } @starts),
    (map { "[1, 2] $_" } @ends),
);

ddg_goodie_test(
    [qw( DDG::Goodie::Shuffle )],
    # Example queries
    'shuffle [1, 2, 3, 4]'   => build_test([1, 2, 3, 4]),
    'a..h in a random order' => build_test(['a'..'h']),
    # Ranges
    'shuffle [1..3]'   => build_test([1, 2, 3]),
    'shuffle a..c'     => build_test(['a', 'b', 'c']),
    'shuffle 1..30'    => build_test([1..30]), # Max items with range
    'shuffle 1..31'    => undef, # Too many range items
    'shuffle 1+7..8'   => undef,
    'shuffle die..die' => undef,
    # Additional trigger forms
    @triggers,
    # Nothing to shuffle
    'shuffle []'  => undef,
    'shuffle [1]' => undef,
    'shuffle'     => undef,
);

done_testing;
