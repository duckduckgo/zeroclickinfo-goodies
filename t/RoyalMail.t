#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'royal_mail';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::RoyalMail )],
    'parcelforce track PBTM8041434001' => test_zci(
        "PBTM8041434001",
        heading => 'Royal Mail / Parcelforce Tracking',
        html =>
            qq(Track this parcel at <a href="http://www.royalmail.com/portal/rm/track?trackNumber=PBTM8041434001">Royal Mail</a> or <a href="http://www.parcelforce.com/track-trace?trackNumber=PBTM8041434001">Parcelforce</a>.)
    ),
    'royal mail track parcel QE001331410GB' => test_zci(
        "QE001331410GB",
        heading => 'Royal Mail / Parcelforce Tracking',
        html =>
            qq(Track this parcel at <a href="http://www.royalmail.com/portal/rm/track?trackNumber=QE001331410GB">Royal Mail</a> or <a href="http://www.parcelforce.com/track-trace?trackNumber=QE001331410GB">Parcelforce</a>.)
    ),
    'track PBTM8237263001' => test_zci(
        "PBTM8237263001",
        heading => 'Royal Mail / Parcelforce Tracking',
        html =>
            qq(Track this parcel at <a href="http://www.royalmail.com/portal/rm/track?trackNumber=PBTM8237263001">Royal Mail</a> or <a href="http://www.parcelforce.com/track-trace?trackNumber=PBTM8237263001">Parcelforce</a>.)
    )
);

done_testing;

