#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "word_list";
zci is_cached   => 1;

my $WC = 10;
my $WCM = $WC - 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Words )],

    'words starting with duck'                  => test_zci(
        qr/^(\w+,\s){$WCM}\w+$/,
        structured_answer => {
            input     => ["$WC words starting with duck"],
            operation => 'Words',
            result    => qr/^(\w+,\s){$WCM}\w+$/
        }
    ),
    '9-letter words like cro*rd'                => test_zci(
        'crossword',
        structured_answer => {
            input     => ["$WC 9-letter words like cro*rd"],
            operation => 'Words',
            result    => 'crossword'
        }
    ),
    '20 words'                                  => test_zci(
        qr/^(\w+,\s){19}\w+$/,
        structured_answer => {
            input     => ['20 words'],
            operation => 'Words',
            result    => qr/^(\w+,\s){19}\w+$/
        }
    ),
    'random words with 4 letters'               => test_zci(
        qr/^(\w{4},\s){$WCM}\w{4}$/,
        structured_answer => {
            input     => ["$WC 4-letter words"],
            operation => 'Words',
            result    => qr/^(\w{4},\s){$WCM}\w{4}$/
        }
    ),
    '5 6-letter words ending in ay'             => test_zci(
        qr/^(\w{6},\s){4}\w{6}$/,
        structured_answer => {
            input     => ["5 6-letter words ending in ay"],
            operation => 'Words',
            result    => qr/^(\w{6},\s){4}\w{6}$/
        }
    ),
    'words like cro----rd'                      => test_zci(
        'crossword',
        structured_answer => {
            input     => ["$WC words like cro....rd"],
            operation => 'Words',
            result    => 'crossword'
        }
    ),
    '20 words like s* having 4 letters'         => test_zci(
        qr/^(s\w{3},\s){19}s\w{3}$/,
        structured_answer => {
            input     => ["20 4-letter words starting with s"],
            operation => 'Words',
            result    => qr/^(s\w{3},\s){19}s\w{3}$/
        }
    ),
    '20 words having 4 characters like st*'     => test_zci(
        qr/^(st\w{2},\s){19}st\w{2}$/,
        structured_answer => {
            input     => ["20 4-letter words starting with st"],
            operation => 'Words',
            result    => qr/^(st\w{2},\s){19}st\w{2}$/
        }
    ),
    '5 random words with 4 letters'             => test_zci(
        qr/^(\w{4},\s){4}\w{4}$/,
        structured_answer => {
            input     => ["5 4-letter words"],
            operation => 'Words',
            result    => qr/^(\w{4},\s){4}\w{4}$/
        }
    ),
    '50 20 letter words like under*'            => test_zci(
        qr/^(under\w{15}(,\s)?)+$/,
        structured_answer => {
            input     => ["50 20-letter words starting with under"],
            operation => 'Words',
            result    => qr/^(under\w{15}(,\s)?)+$/
        }
    ),
    '10 8 letter words beginning with alt'      => test_zci(
        qr/^(alt\w{5}(,\s)?){10}$/,
        structured_answer => {
            input     => ["10 8-letter words starting with alt"],
            operation => 'Words',
            result    => qr/^(alt\w{5}(,\s)?){10}$/
        }
    ),
    '10 8 letter words that start with alt--'   => test_zci(
        qr/^(alt\w{5}(,\s)?){10}$/,
        structured_answer => {
            input     => ["10 8-letter words starting with alt"],
            operation => 'Words',
            result    => qr/^(alt\w{5}(,\s)?){10}$/
        }
    ),
    '10 6-character words ending in ex'         => test_zci(
        qr/^(\w{4}ex(,\s)?){10}$/,
        structured_answer => {
            input     => ["10 6-letter words ending in ex"],
            operation => 'Words',
            result    => qr/^(\w{4}ex(,\s)?){10}$/
        }
    ),
    '6-character word which ends in ex'         => test_zci(
        qr/^\w{4}ex$/,
        structured_answer => {
            input     => ["one 6-letter word ending in ex"],
            operation => 'Words',
            result    => qr/^\w{4}ex$/
        }
    ),
    '9-CHARACTER WorD LiKE CRO***rd'            => test_zci(
        'crossword',
        structured_answer => {
            input     => ["one 9-letter word like cro*rd"],
            operation => 'Words',
            result    => 'crossword'
        }
    ),
    'words like rain??w'                        => test_zci(
        qr/^(rain..w(,\s)?)+$/,
        structured_answer => {
            input     => ["$WC words like rain..w"],
            operation => 'Words',
            result    => qr/^(rain..w(,\s)?)+$/
        }
    ),
    'words like rain..w'                        => test_zci(
        qr/^(rain..w(,\s)?)+$/,
        structured_answer => {
            input     => ["$WC words like rain..w"],
            operation => 'Words',
            result    => qr/^(rain..w(,\s)?)+$/
        }
    ),
    '51 8 letter words starting'                => test_zci(
        qr/^(\w{8},\s){49}\w{8}$/,
        structured_answer => {
            input     => ["50 8-letter words"],
            operation => 'Words',
            result    => qr/^(\w{8},\s){49}\w{8}$/
        }
    ),
    '8 letter words starting with'              => test_zci(
        qr/^(\w{8},\s){$WCM}\w{8}$/,
        structured_answer => {
            input     => ["$WC 8-letter words"],
            operation => 'Words',
            result    => qr/^(\w{8},\s){$WCM}\w{8}$/
        }
    ),
    '5 8 letter words starting with ***'        => test_zci(
        qr/^(\w{8},\s){4}\w{8}$/,
        structured_answer => {
            input     => ["5 8-letter words"],
            operation => 'Words',
            result    => qr/^(\w{8},\s){4}\w{8}$/
        }
    ),
    '5 8 letter words like ***'                 => test_zci(
        qr/^(\w{8},\s){4}\w{8}$/,
        structured_answer => {
            input     => ["5 8-letter words"],
            operation => 'Words',
            result    => qr/^(\w{8},\s){4}\w{8}$/
        }
    ),
    '5 words like ........'                     => test_zci(
        qr/^(\w{8},\s){4}\w{8}$/,
        structured_answer => {
            input     => ["5 8-letter words"],
            operation => 'Words',
            result    => qr/^(\w{8},\s){4}\w{8}$/
        }
    ),
    
    '50 words like *z*z*z*'                     => undef, # Excessive backtracking
    '50 words like *...'                        => test_zci(
        qr/^(\w{3},\s){49}\w{3}$/,
        structured_answer => {
            input     => ["50 words like *..."],
            operation => 'Words',
            result    => qr/^(\w{3},\s){49}\w{3}$/
        }
    ),
    
    'letter words'                              => undef, # Too wrong or unrelated queries
    'words like quaternion'                     => undef,
    'words like doesnotexist'                   => undef,
    'words test what'                           => undef,
    'words'                                     => undef,
);

done_testing;
