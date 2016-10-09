#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "bpmto_ms";
zci is_cached   => 1;

my $plaintext_120 = "120 bpm in milliseconds:";
   $plaintext_120 .= "\nWhole Note: 2000, Triplet: 1333, Dotted: 3000";
   $plaintext_120 .= "\nHalf Note: 1000, Triplet: 667, Dotted: 1500";
   $plaintext_120 .= "\nQuarter Note: 500, Triplet: 333, Dotted: 750";
   $plaintext_120 .= "\n1/8 Note: 250, Triplet: 167, Dotted: 375";
   $plaintext_120 .= "\n1/16 Note: 125, Triplet: 83, Dotted: 188";
   $plaintext_120 .= "\n1/32 Note: 63, Triplet: 42, Dotted: 94";

my $plaintext_61 = "61 bpm in milliseconds:";
   $plaintext_61 .= "\nWhole Note: 3934, Triplet: 2623, Dotted: 5902";
   $plaintext_61 .= "\nHalf Note: 1967, Triplet: 1311, Dotted: 2951";
   $plaintext_61 .= "\nQuarter Note: 984, Triplet: 656, Dotted: 1475";
   $plaintext_61 .= "\n1/8 Note: 492, Triplet: 328, Dotted: 738";
   $plaintext_61 .= "\n1/16 Note: 246, Triplet: 164, Dotted: 369";
   $plaintext_61 .= "\n1/32 Note: 123, Triplet: 82, Dotted: 184";

ddg_goodie_test(
    [qw( DDG::Goodie::BPMToMs)],

    "120 beats per minute to ms" => test_zci(
        $plaintext_120,
        structured_answer => {
            data => ignore(),
#                   [
#                 {
#                     note_type => "Whole Note",
#                     triplet => 1333,
#                     dotted => 3000,
#                     milliseconds => 2000,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "Half Note",
#                     triplet => 667,
#                     dotted => 1500,
#                     milliseconds => 1000,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "Quarter Note",
#                     triplet => 333,
#                     dotted => 750,
#                     milliseconds => 500,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "1/8 Note",
#                     triplet => 167,
#                     dotted => 375,
#                     milliseconds => 250,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "1/16 Note",
#                     triplet => 83,
#                     dotted => 188,
#                     milliseconds => 125,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "1/32 Note",
#                     triplet => 42,
#                     dotted => 94,
#                     milliseconds => 63,
#                     image => re(qr/.*/)
#                 }
#             ],
            meta => {
                sourceUrl => "https://wikipedia.org/wiki/Tempo#Beats_per_minute",
                sourceName => "Wikipedia"
            },
            templates => {
                group => "base",
                detail => 0,
                options => {
                    content => "DDH.bpmto_ms.content"
                }
            }
        }
    ),

    "61 beats per minute to ms" => test_zci(
        $plaintext_61,
        structured_answer => {
            data => ignore(),
#                   [
#                 {
#                     note_type => "Whole Note",
#                     triplet => 2623,
#                     dotted => 5902,
#                     milliseconds => 3934,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "Half Note",
#                     triplet => 1311,
#                     dotted => 2951,
#                     milliseconds => 1967,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "Quarter Note",
#                     triplet => 656,
#                     dotted => 1475,
#                     milliseconds => 984,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "1/8 Note",
#                     triplet => 328,
#                     dotted => 738,
#                     milliseconds => 492,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "1/16 Note",
#                     triplet => 164,
#                     dotted => 369,
#                     milliseconds => 246,
#                     image => re(qr/.*/)
#                 },
#                 {
#                     note_type => "1/32 Note",
#                     triplet => 82,
#                     dotted => 184,
#                     milliseconds => 123,
#                     image => re(qr/.*/)
#                 }
#             ],
            meta => {
                sourceUrl => "https://wikipedia.org/wiki/Tempo#Beats_per_minute",
                sourceName => "Wikipedia"
            },
            templates => {
                group => "base",
                detail => 0,
                options => {
                    content => "DDH.bpmto_ms.content"
                }
            }
        }
    ),

    '-1 bpm to ms' => undef,
    'some bpm to ms' => undef,
    'bpm' => undef,
);

done_testing;
