#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'fedex';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::FedEx )],
        'fedex 9241990100130206401644' => test_zci(
            "9241990100130206401644",
            heading => 'FedEx Shipment Tracking',
            html => qq(Track this shipment at <a href="https://www.fedex.com/apps/fedextrack/?tracknumbers=9241990100130206401644&action=track">FedEx</a>.)
        ),
        'federal express 9241990100130206401644' => test_zci(
            "9241990100130206401644",
            heading => 'FedEx Shipment Tracking',
            html => qq(Track this shipment at <a href="https://www.fedex.com/apps/fedextrack/?tracknumbers=9241990100130206401644&action=track">FedEx</a>.)
        ),
        '178440515632684' => test_zci(
            "178440515632684",
            heading => 'FedEx Shipment Tracking',
            html    => qq(Track this shipment at <a href="https://www.fedex.com/apps/fedextrack/?tracknumbers=178440515632684&action=track">FedEx</a>.)
        ),
        '178440515682684' => undef, # Transcription error turns a 3 into an 8. Fails checksum; not a tracking number.
        '9612804882227378545377' => test_zci(
            "9612804882227378545377",
            heading => 'FedEx Shipment Tracking',
            html => qq(Track this shipment at <a href="https://www.fedex.com/apps/fedextrack/?tracknumbers=9612804882227378545377&action=track">FedEx</a>.)
        )
);

done_testing;
