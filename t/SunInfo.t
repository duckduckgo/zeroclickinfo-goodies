#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sun_info';
zci is_cached   => 0;

# Presume sun will rise in the morning and set at night year round in PA.
my @now = (qr/^On.*Phoenixville, PA.*am.*pm\.$/, html => qr/Phoenixville.*am.*pm/);
my @aug = (qr/^On 30 Aug.*am.*pm\.$/,            html => qr/Phoenixville.*am.*pm/);
my @exact = (
    'On 01 Jan 2015, sunrise in Phoenixville, PA is at 7:23am; sunset at 4:46pm.',
    html =>
      "<div class='zci--suninfo text--secondary'>On <span class='text--primary'>01 Jan 2015</span>, sunrise in <span class='text--primary'>Phoenixville, PA</span> is at <span class='text--primary'>7:23am</span>; sunset at <span class='text--primary'>4:46pm</span>.</div>"
);

ddg_goodie_test([qw(
          DDG::Goodie::SunInfo
          )
    ],
    'sunrise'                             => test_zci(@now),
    'what time is sunrise'                => test_zci(@now),
    'sunset'                              => test_zci(@now),
    'what time is sunset'                 => test_zci(@now),
    'sunrise for aug 30'                  => test_zci(@aug),
    'sunset for aug 30?'                  => test_zci(@aug),
    'sunset on 2015-01-01'                => test_zci(@exact),
    'what time is sunrise on 2015-01-01?' => test_zci(@exact),
    'sunset for pilly'                    => undef,
    'sunrise on mars'                     => undef,
    'sunset boulevard'                    => undef,
    'tequila sunrise'                     => undef,
    'sunrise mall'                        => undef,
    'after the sunset'                    => undef,
);

done_testing;
