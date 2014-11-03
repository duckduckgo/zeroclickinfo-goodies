#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "country_codes";
zci is_cached   => 1;

my $text = qq(<a href="https://en.wikipedia.org/wiki/ISO_3166-1">ISO 3166</a>:);

ddg_goodie_test(
        [ 'DDG::Goodie::CountryCodes' ],
        "country code Japan"                  => test_zci(qq(ISO 3166: Japan - jp), html => qq($text Japan - jp)),
        "3 letter country code Japan"         => test_zci(qq(ISO 3166: Japan - jpn), html => qq($text Japan - jpn)),
        "3 letter country code China"         => test_zci(qq(ISO 3166: China - chn), html => qq($text China - chn)),
        "Japan 3 letter country code"         => test_zci(qq(ISO 3166: Japan - jpn), html => qq($text Japan - jpn)),
        "Russia 2 letter country code"        => test_zci(qq(ISO 3166: Russia - ru), html => qq($text Russia - ru)),
        "two letter country code Japan"       => test_zci(qq(ISO 3166: Japan - jp), html => qq($text Japan - jp)),
        "three letter country code for Japan" => test_zci(qq(ISO 3166: Japan - jpn), html => qq($text Japan - jpn)),
        "numerical iso code japan"            => test_zci(qq(ISO 3166: Japan - 392), html => qq($text Japan - 392)),
        "iso code for spain"                  => test_zci(qq(ISO 3166: Spain - es), html => qq($text Spain - es)),
        "country code jp"                     => test_zci(qq(ISO 3166: Japan - jp), html => qq($text Japan - jp)),
        "japan numerical iso 3166"            => test_zci(qq(ISO 3166: Japan - 392), html => qq($text Japan - 392)),
        'country code for gelgamek' => undef,
        'iso code for english'     => undef,
);

done_testing;
