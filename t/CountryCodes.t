#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "country_codes";
zci is_cached   => 1;

my $text = '</div><div class="zci__subheader">ISO 3166 Country code for';

ddg_goodie_test(
        [ 'DDG::Goodie::CountryCodes' ],
        "country code Japan"                     => test_zci(
            qq(ISO 3166: Japan - jp),
            structured_answer => {
                input => ['Japan'],
                operation => 'ISO 3166 Country code',
                result => 'jp'
            }
        ),
        "3 letter country code Japan"            => test_zci(
             qq(ISO 3166: Japan - jpn),
             structured_answer => {
                input => ['Japan'],
                operation => 'ISO 3166 Country code',
                result => 'jpn'
            } 
        ),
        "3 letter country code of China"         => test_zci(
             qq(ISO 3166: China - chn),
             structured_answer => {
                input => ['China'],
                operation => 'ISO 3166 Country code',
                result => 'chn'
            }
        ),
        "Japan 3 letter country code"            => test_zci(
             qq(ISO 3166: Japan - jpn),
             structured_answer => {
                input => ['Japan'],
                operation => 'ISO 3166 Country code',
                result => 'jpn'
            }
        ),
        "Russia two letter country code"         => test_zci(
             qq(ISO 3166: Russia - ru),
             structured_answer => {
                input => ['Russia'],
                operation => 'ISO 3166 Country code',
                result => 'ru'
            }
        ),
        "two letter country code Japan"          => test_zci(
             qq(ISO 3166: Japan - jp),
             structured_answer => {
                input => ['Japan'],
                operation => 'ISO 3166 Country code',
                result => 'jp'
            }
        ),
        "three letter country code for Japan"    => test_zci(
             qq(ISO 3166: Japan - jpn),
             structured_answer => {
                input => ['Japan'],
                operation => 'ISO 3166 Country code',
                result => 'jpn'
            }
        ),
        "numerical iso code japan"               => test_zci(
             qq(ISO 3166: Japan - 392),
             structured_answer => {
                input => ['Japan'],
                operation => 'ISO 3166 Country code',
                result => '392'
            }
        ),
        "iso code for spain"                     => test_zci(
             qq(ISO 3166: Spain - es),
             structured_answer => {
                input => ['Spain'],
                operation => 'ISO 3166 Country code',
                result => 'es'
            } 
        ),
        "country code jp"                        => test_zci(
             qq(ISO 3166: Japan - jp),
             structured_answer => {
                input => ['Japan'],
                operation => 'ISO 3166 Country code',
                result => 'jp'
            }
        ),
        "japan numerical iso 3166"               => test_zci(
             qq(ISO 3166: Japan - 392),
             structured_answer => {
                input => ['Japan'],
                operation => 'ISO 3166 Country code',
                result => '392'
            }
        ),
        "united states of america iso code"      => test_zci(
             qq(ISO 3166: United states of america - us),
             structured_answer => {
                input => ['United states of america'],
                operation => 'ISO 3166 Country code',
                result => 'us'
            }
        ),
        "3 letter iso code isle of man"          => test_zci(
             qq(ISO 3166: Isle of man - imn), 
             structured_answer => {
                input => ['Isle of man'],
                operation => 'ISO 3166 Country code',
                result => 'imn'
            }
        ),
        'country code for gelgamek' => undef,
        'iso code for english'     => undef,
);

done_testing;
