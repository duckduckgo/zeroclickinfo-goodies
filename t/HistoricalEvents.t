#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'historical_events';
zci is_cached   => 1;

sub build_structured_answer {
    my ($subtitle, $link) = @_;

    return "Yes: $link",
        structured_answer => {

            data => {
                title => 'Yes',
                subtitle => "$subtitle",
                url => $link
            },

            meta => {
                sourceName => "Wikipedia",
                sourceUrl => $link
            },

            templates => {
                group => 'info'
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

my $moon_landing_url = "https://en.wikipedia.org/wiki/Moon_landing";
my $holocaust_url = "https://en.wikipedia.org/wiki/The_Holocaust";

ddg_goodie_test(
    [qw( DDG::Goodie::HistoricalEvents )],

    'is the moon landing real'              => build_test('Is the Moon landing real?', $moon_landing_url),
    'was the moon landing real?'            => build_test('Was the Moon landing real?', $moon_landing_url),
    'did the moon landing happen'           => build_test('Did the Moon landing happen?', $moon_landing_url),
    'did the moon landing really happen'    => build_test('Did the Moon landing really happen?', $moon_landing_url),
    'did the moon landing actually happen'  => build_test('Did the Moon landing actually happen?', $moon_landing_url),

    'is the holocaust real'                 => build_test('Is the Holocaust real?', $holocaust_url),
    'was the holocaust real?'               => build_test('Was the Holocaust real?', $holocaust_url),
    'did the holocaust happen'              => build_test('Did the Holocaust happen?', $holocaust_url),
    'did the holocaust really happen'       => build_test('Did the Holocaust really happen?', $holocaust_url),
    'did the holocaust actually happen'     => build_test('Did the Holocaust actually happen?', $holocaust_url),

    'when was the holocaust' => undef,
    'is the moon landing a hoax?' => undef,
);

done_testing;
