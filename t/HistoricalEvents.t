#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'historical_events';
zci is_cached   => 1;

sub build_structured_answer {
    my ($pre, $event, $post, $link) = @_;

    return "Yes: $link",
        structured_answer => {

            data => {
                title => 'Yes',
                subtitle => "$pre the $event $post?",
                url => $link
            },

            templates => {
                group => 'text'
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

my $moon_landing_url = "https://en.wikipedia.org/wiki/Moon_landing";
my $holocaust_url = "https://en.wikipedia.org/wiki/The_Holocaust";

ddg_goodie_test(
    [qw( DDG::Goodie::HistoricalEvents )],

    'is the moon landing real' => build_test('Is', 'Moon landing', 'real', $moon_landing_url),
    'is the moon landing real?' => build_test('Is', 'Moon landing', 'real', $moon_landing_url),
    'did the moon landing happen' => build_test('Did', 'Moon landing', 'happen', $moon_landing_url),
    'did the moon landing really happen' => build_test('Did', 'Moon landing', 'really happen', $moon_landing_url),
    'did the moon landing actually happen' => build_test('Did', 'Moon landing', 'actually happen', $moon_landing_url),

    'is the holocaust real' => build_test('Is', 'Holocaust', 'real', $holocaust_url),
    'is the holocaust real?' => build_test('Is', 'Holocaust', 'real', $holocaust_url),
    'did the holocaust happen' => build_test('Did', 'Holocaust', 'happen', $holocaust_url),
    'did the holocaust really happen' => build_test('Did', 'Holocaust', 'really happen', $holocaust_url),
    'did the holocaust actually happen' => build_test('Did', 'Holocaust', 'actually happen', $holocaust_url),

    'when was the holocaust' => undef,
    'is the moon landing a hoax?' => undef,
);

done_testing;
