#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sun_info';
zci is_cached   => 0;

my @now = (qr/^Location => Phoenixville, PA.*pm$/, html => qr/Location:.*pm/);
my @aug = (qr/^Location => Phoenixville, PA | Date => 30 Aug.*pm$/, html => qr/Location:.*pm/);
my @exact = (
    'Location => Phoenixville, PA | Date => 01 Jan 2015 | Sunrise =>  7:23am | Sunset =>  4:46pm',
    html =>
      '<div><span class="suninfo__label text--secondary">Location: </span><span class="text--primary">Phoenixville, PA</span></div><div><span class="suninfo__label text--secondary">Date: </span><span class="text--primary">01 Jan 2015</span></div><div><span class="suninfo__label text--secondary">Sunrise: </span><span class="text--primary"> 7:23am</span></div><div><span class="suninfo__label text--secondary">Sunset: </span><span class="text--primary"> 4:46pm</span></div><style> .zci--answer .suninfo__label {display: inline-block; min-width: 90px}</style>'
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
