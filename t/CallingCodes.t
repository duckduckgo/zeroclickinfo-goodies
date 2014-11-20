#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "calling_codes";
zci is_cached   => 1;

my $txt = "is the international calling code for";

ddg_goodie_test(
    [qw( DDG::Goodie::CallingCodes )],
    # Example queries
    "calling code 55" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    "dialing code brazil" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    "dialing code +55" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    "country calling code 55" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    # Other working queries.
    "calling code for the sudan" => test_zci(
        '', 
        html => '<div class="zci__caption">+249</div><div class="zci__subheader">Country Dialing code for Sudan</div>',
    ),
    "calling code for vatican" => test_zci(
        '', 
        html => '<div class="zci__caption">+379</div><div class="zci__subheader">Country Dialing code for the Holy See (Vatican City State)</div>',
    ),
    "379 calling code vatican" => test_zci(
        '', 
        html => '<div class="zci__caption">+379</div><div class="zci__subheader">Country Dialing code for the Holy See (Vatican City State)</div>',
    ),
    "vatican calling code 379" => test_zci(
        '', 
        html => '<div class="zci__caption">+379</div><div class="zci__subheader">Country Dialing code for the Holy See (Vatican City State)</div>',
    ),
    "country dial in code brazil" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    "calling code 55 Brazil" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    "calling code for Brazil +55" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    "calling code +55 for Brazil" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    "Brazil calling code +55" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    "+55 calling code for Brazil" => test_zci(
        '', 
        html => '<div class="zci__caption">+55</div><div class="zci__subheader">Country Dialing code for Brazil</div>',
    ),
    "calling code 65" => test_zci(
        '',
        html => '<div class="zci__caption">+65</div><div class="zci__subheader">Country Dialing code for Singapore</div>',
    ),
    "calling code +65" => test_zci(
        '',
        html => '<div class="zci__caption">+65</div><div class="zci__subheader">Country Dialing code for Singapore</div>',
    ),
    "dialing code +65" => test_zci(
        '',
        html => '<div class="zci__caption">+65</div><div class="zci__subheader">Country Dialing code for Singapore</div>',
    ),
    "international dial-in code +65" => test_zci(
        '',
        html => '<div class="zci__caption">+65</div><div class="zci__subheader">Country Dialing code for Singapore</div>',
    ),
    "calling code for Singapore" => test_zci(
        '',
        html => '<div class="zci__caption">+65</div><div class="zci__subheader">Country Dialing code for Singapore</div>',
    ),
    "country calling code for Singapore" => test_zci(
        '',
        html => '<div class="zci__caption">+65</div><div class="zci__subheader">Country Dialing code for Singapore</div>',
    ),
    "dialing code Singapore" => test_zci(
        '',
        html => '<div class="zci__caption">+65</div><div class="zci__subheader">Country Dialing code for Singapore</div>',
    ),
    "dialing code for Singapore" => test_zci(
        '',
        html => '<div class="zci__caption">+65</div><div class="zci__subheader">Country Dialing code for Singapore</div>',
    ),
    "dialing code for UK" => test_zci(
        '',
        html => '<div class="zci__caption">+44</div><div class="zci__subheader">Country Dialing code for the United Kingdom</div>',
    ),
    "calling code for the UK" => test_zci(
        '',
        html => '<div class="zci__caption">+44</div><div class="zci__subheader">Country Dialing code for the United Kingdom</div>',
    ),
    "uk calling code" => test_zci(
        '',
        html => '<div class="zci__caption">+44</div><div class="zci__subheader">Country Dialing code for the United Kingdom</div>',
    ),
    "gb calling code" => test_zci(
        '',
        html => '<div class="zci__caption">+44</div><div class="zci__subheader">Country Dialing code for the United Kingdom</div>',
    ),
    "calling code for antigua" => test_zci(
        '',
        html => '<div class="zci__caption">+1</div><div class="zci__subheader">Country Dialing code for Antigua and Barbuda</div>',
    ),
    "calling code for barbuda" => test_zci(
        '',
        html => '<div class="zci__caption">+1</div><div class="zci__subheader">Country Dialing code for Antigua and Barbuda</div>',
    ),
    "calling code for trinidad" => test_zci(
        '',
        html => '<div class="zci__caption">+1</div><div class="zci__subheader">Country Dialing code for Trinidad and Tobago</div>',
    ),
    "calling code for tobago" => test_zci(
        '',
        html => '<div class="zci__caption">+1</div><div class="zci__subheader">Country Dialing code for Trinidad and Tobago</div>',
    ),
    "dialing code for US" => test_zci(
        '',
        html => '<div class="zci__caption">+1</div><div class="zci__subheader">Country Dialing code for the United States</div>',
    ),
    "calling code for america" => test_zci(
        '',
        html => '<div class="zci__caption">+1</div><div class="zci__subheader">Country Dialing code for the United States</div>',
    ),
    "dial in code +1" => test_zci(
        '',
        html => '<div class="zci__caption">+1</div><div class="zci__subheader">Country Dialing code for Antigua and Barbuda, Anguilla, American Samoa, Barbados, Bermuda, the Bahamas, Canada, Dominica, the Dominican Republic, Grenada, Guam, Jamaica, Saint Lucia, Saint Kitts and Nevis, the Cayman Islands, the Northern Mariana Islands, Montserrat, Puerto Rico, Turks and Caicos Islands, Trinidad and Tobago, the United States, Saint Vincent and the Grenadines, the British Virgin Islands, and the US Virgin Islands</div>',
    ),
    "calling code +7" => test_zci(
        '',
        html => '<div class="zci__caption">+7</div><div class="zci__subheader">Country Dialing code for the Russian Federation and Kazakhstan</div>',
    ),
    "calling code for russia" => test_zci(
        '',
        html => '<div class="zci__caption">+7</div><div class="zci__subheader">Country Dialing code for the Russian Federation</div>',
    ),
    "dial in code to the Russian Federation" => test_zci(
        '',
        html => '<div class="zci__caption">+7</div><div class="zci__subheader">Country Dialing code for the Russian Federation</div>',
    ),
    "calling code for south korea" => test_zci(
        '',
        html => '<div class="zci__caption">+82</div><div class="zci__subheader">Country Dialing code for the Republic of Korea</div>',
    ),
    "calling code for the republic of korea" => test_zci(
        '',
        html => '<div class="zci__caption">+82</div><div class="zci__subheader">Country Dialing code for the Republic of Korea</div>',
    ),
    "calling code for north korea" => test_zci(
        '',
        html => '<div class="zci__caption">+850</div><div class="zci__subheader">Country Dialing code for the Democratic People&#39;s Republic of Korea</div>',
    ),
    "calling code for the democratic people's republic of korea" => test_zci(
        '',
        html => '<div class="zci__caption">+850</div><div class="zci__subheader">Country Dialing code for the Democratic People&#39;s Republic of Korea</div>',
    ),
    # Properly negative
    'country code for the netherlands' => undef,
    'country code for north korea'     => undef,
    'country code +850'                => undef,
    "calling code for the moon"        => undef,
    "calling code +3boop"              => undef,
    "calling code 599"                 => undef,
);

done_testing;
