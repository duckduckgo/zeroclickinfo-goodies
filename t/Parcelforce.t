#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'parcelforce';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Parcelforce )],
    'parcelforce track PBTM8041434001' => test_zci(
        "PBTM8041434001",
        heading => 'Parcelforce Tracking',
        html =>
            qq(Track this parcel at <a href="http://www.parcelforce.com/track-trace?trackNumber=PBTM8041434001">Parcelforce</a>.)
    ),
    'royal mail track parcel QE001331410GB' => test_zci(
        "QE001331410GB",
        heading => 'Parcelforce Tracking',
        html =>
            qq(Track this parcel at <a href="http://www.parcelforce.com/track-trace?trackNumber=QE001331410GB">Parcelforce</a>.)
    ),
    'track PBTM8237263001' => test_zci(
        "PBTM8237263001",
        heading => 'Parcelforce Tracking',
        html =>
            qq(Track this parcel at <a href="http://www.parcelforce.com/track-trace?trackNumber=PBTM8237263001">Parcelforce</a>.)
    ),
    'luhn 1234554651' => undef,
    'cc737873589FR' => undef,
    'KB2553549' => undef
);

done_testing;
