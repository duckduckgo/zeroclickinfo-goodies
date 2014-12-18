#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'morse';
zci is_cached   => 1;


my @sos = ('... --- ...', structured_answer => { input => ['SOS'], operation => 'Morse code conversion', result => '... --- ...'});
my @duck = ('.... . .-.. .-.. --- --..--  -.. ..- -.-. -.-', structured_answer => { input => ['hello, duck'], operation => 'Morse code conversion', result => '.... . .-.. .-.. --- --..--  -.. ..- -.-. -.-'});

ddg_goodie_test([qw(
          DDG::Goodie::Morse
          )
    ],
    'morse ... --- ...' => test_zci(
        'SOS',
        structured_answer => {
            input     => ['... --- ...'],
            operation => 'Morse code conversion',
            result    => 'SOS'
        }
    ),
    'morse SOS'              => test_zci(@sos),
    'morse code SOS'         => test_zci(@sos),
    'SOS morse'              => test_zci(@sos),
    'SOS morse code'         => test_zci(@sos),
    'morse hello, duck'      => test_zci(@duck),
    'morse code hello, duck' => test_zci(@duck),
);

done_testing;
