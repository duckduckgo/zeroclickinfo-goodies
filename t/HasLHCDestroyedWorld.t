#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "has_lhcdestroyed_world";
zci is_cached   => 1;

# The one structured answer containing the message, "Nope."
my @no = (
    "Nope.",
    structured_answer => {
        id => 'has_lhcdestroyed_world',
        name => 'Answer',
        data => {
            title => "Has it?",
            subtitle => "Nope."
        },
        meta => {
            sourceName => "Has the Large Hadron Collider destroyed the world yet?",
            sourceUrl => "http://hasthelargehadroncolliderdestroyedtheworldyet.com/"
        },
        templates => {
            group => "text",
            moreAt => 1
        }
    }
);

ddg_goodie_test(
    [qw( DDG::Goodie::HasLHCDestroyedWorld )],
    'has the large hadron collider destroyed the world yet' => test_zci(@no),
    'has the large hadron collider destroyed the world'     => test_zci(@no),
    'has the lhc destroyed the world yet'                   => test_zci(@no),
    'has the lhc destroyed the world'                       => test_zci(@no),
    'has the large hadron collider destroyed the earth yet' => test_zci(@no),
    'has the large hadron collider destroyed the earth'     => test_zci(@no),
    'has the lhc destroyed the earth yet'                   => test_zci(@no),
    'has the lhc destroyed the earth'                       => test_zci(@no),

    'in science fiction has the large hadron collider destroyed the world' => undef,
    'large hadron collider'                                 => undef,
    'could the large hadron collider destroyed the world'   => undef,
    'will the large hadron collider destroy the earth'      => undef
);

done_testing;
