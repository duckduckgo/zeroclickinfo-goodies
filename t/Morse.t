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
    'morse code for ... --- ...' => test_zci(
        'SOS',
        structured_answer => {
            input     => ['... --- ...'],
            operation => 'Morse code conversion',
            result    => 'SOS'
        }
    ),
    'morse code for SOS'            => test_zci(@sos),
    'morse for SOS'                 => test_zci(@sos),
    'SOS to morse code'             => test_zci(@sos),
    'SOS to morse'                  => test_zci(@sos),
    'morse code for hello, duck'    => test_zci(@duck),
    'hello, duck to morse code'     => test_zci(@duck),
    'morse for hello, duck'         => test_zci(@duck),
    'hello, duck to morse'          => test_zci(@duck),
    'morse SOS'                     => undef,
    'morse code SOS'                => undef,
    'SOS morse'                     => undef,
    'SOS morse code'                => undef,
    'morse hello, duck'             => undef,
    'morse code hello, duck'        => undef,
    'morse code for cheatsheet'     => undef,
    'morse code for cheat sheet'    => undef,
);

done_testing;
