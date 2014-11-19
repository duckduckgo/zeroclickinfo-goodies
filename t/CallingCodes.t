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
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['+55'],
            operation => 'international calling code',
            result    => 'Brazil'
        }
    ),
    "dialing code brazil" => test_zci(
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['Brazil'],
            operation => 'international calling code',
            result    => '+55'
        }
    ),
    "dialing code +55" => test_zci(
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['+55'],
            operation => 'international calling code',
            result    => 'Brazil'
        }
    ),
    "country calling code 55" => test_zci(
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['+55'],
            operation => 'international calling code',
            result    => 'Brazil'
        }
    ),
    # Other working queries.
    "calling code for the sudan" => test_zci(
        "+249 $txt Sudan.",
        structured_answer => {
            input     => ['Sudan'],
            operation => 'international calling code',
            result    => '+249'
        }
    ),
    "calling code for vatican" => test_zci(
        "+379 $txt the Holy See (Vatican City State).",
        structured_answer => {
            input     => ['the Holy See (Vatican City State)'],
            operation => 'international calling code',
            result    => '+379'
        }
    ),
    "379 calling code vatican" => test_zci(
        "+379 $txt the Holy See (Vatican City State).",
        structured_answer => {
            input     => ['+379'],
            operation => 'international calling code',
            result    => 'the Holy See (Vatican City State)'
        }
    ),
    "vatican calling code 379" => test_zci(
        "+379 $txt the Holy See (Vatican City State).",
        structured_answer => {
            input     => ['the Holy See (Vatican City State)'],
            operation => 'international calling code',
            result    => '+379'
        }
    ),
    "country dial in code brazil" => test_zci(
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['Brazil'],
            operation => 'international calling code',
            result    => '+55'
        }
    ),
    "calling code 55 Brazil" => test_zci(
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['+55'],
            operation => 'international calling code',
            result    => 'Brazil'
        }
    ),
    "calling code for Brazil +55" => test_zci(
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['Brazil'],
            operation => 'international calling code',
            result    => '+55'
        }
    ),
    "calling code +55 for Brazil" => test_zci(
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['+55'],
            operation => 'international calling code',
            result    => 'Brazil'
        }
    ),
    "Brazil calling code +55" => test_zci(
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['Brazil'],
            operation => 'international calling code',
            result    => '+55'
        }
    ),
    "+55 calling code for Brazil" => test_zci(
        "+55 $txt Brazil.",
        structured_answer => {
            input     => ['+55'],
            operation => 'international calling code',
            result    => 'Brazil'
        }
    ),
    "calling code 65" => test_zci(
        "+65 $txt Singapore.",
        structured_answer => {
            input     => ['+65'],
            operation => 'international calling code',
            result    => 'Singapore'
        }
    ),
    "calling code +65" => test_zci(
        "+65 $txt Singapore.",
        structured_answer => {
            input     => ['+65'],
            operation => 'international calling code',
            result    => 'Singapore'
        }
    ),
    "dialing code +65" => test_zci(
        "+65 $txt Singapore.",
        structured_answer => {
            input     => ['+65'],
            operation => 'international calling code',
            result    => 'Singapore'
        }
    ),
    "international dial-in code +65" => test_zci(
        "+65 $txt Singapore.",
        structured_answer => {
            input     => ['+65'],
            operation => 'international calling code',
            result    => 'Singapore'
        }
    ),
    "calling code for Singapore" => test_zci(
        "+65 $txt Singapore.",
        structured_answer => {
            input     => ['Singapore'],
            operation => 'international calling code',
            result    => '+65'
        }
    ),
    "country calling code for Singapore" => test_zci(
        "+65 $txt Singapore.",
        structured_answer => {
            input     => ['Singapore'],
            operation => 'international calling code',
            result    => '+65'
        }
    ),
    "dialing code Singapore" => test_zci(
        "+65 $txt Singapore.",
        structured_answer => {
            input     => ['Singapore'],
            operation => 'international calling code',
            result    => '+65'
        }
    ),
    "dialing code for Singapore" => test_zci(
        "+65 $txt Singapore.",
        structured_answer => {
            input     => ['Singapore'],
            operation => 'international calling code',
            result    => '+65'
        }
    ),
    "dialing code for UK" => test_zci(
        "+44 $txt the United Kingdom.",
        structured_answer => {
            input     => ['the United Kingdom'],
            operation => 'international calling code',
            result    => '+44'
        }
    ),
    "calling code for the UK" => test_zci(
        "+44 $txt the United Kingdom.",
        structured_answer => {
            input     => ['the United Kingdom'],
            operation => 'international calling code',
            result    => '+44'
        }
    ),
    "uk calling code" => test_zci(
        "+44 $txt the United Kingdom.",
        structured_answer => {
            input     => ['the United Kingdom'],
            operation => 'international calling code',
            result    => '+44'
        }
    ),
    "gb calling code" => test_zci(
        "+44 $txt the United Kingdom.",
        structured_answer => {
            input     => ['the United Kingdom'],
            operation => 'international calling code',
            result    => '+44'
        }
    ),
    "calling code for antigua" => test_zci(
        "+1 $txt Antigua and Barbuda.",
        structured_answer => {
            input     => ['Antigua and Barbuda'],
            operation => 'international calling code',
            result    => '+1'
        }
    ),
    "calling code for barbuda" => test_zci(
        "+1 $txt Antigua and Barbuda.",
        structured_answer => {
            input     => ['Antigua and Barbuda'],
            operation => 'international calling code',
            result    => '+1'
        }
    ),
    "calling code for trinidad" => test_zci(
        "+1 $txt Trinidad and Tobago.",
        structured_answer => {
            input     => ['Trinidad and Tobago'],
            operation => 'international calling code',
            result    => '+1'
        }
    ),
    "calling code for tobago" => test_zci(
        "+1 $txt Trinidad and Tobago.",
        structured_answer => {
            input     => ['Trinidad and Tobago'],
            operation => 'international calling code',
            result    => '+1'
        }
    ),
    "dialing code for US" => test_zci(
        "+1 $txt the United States.",
        structured_answer => {
            input     => ['the United States'],
            operation => 'international calling code',
            result    => '+1'
        }
    ),
    "calling code for america" => test_zci(
        "+1 $txt the United States.",
        structured_answer => {
            input     => ['the United States'],
            operation => 'international calling code',
            result    => '+1'
        }
    ),
    "dial in code +1" => test_zci(
        "+1 $txt Antigua and Barbuda, Anguilla, American Samoa, Barbados, Bermuda, the Bahamas, Canada, Dominica, the Dominican Republic, Grenada, Guam, Jamaica, Saint Lucia, Saint Kitts and Nevis, the Cayman Islands, the Northern Mariana Islands, Montserrat, Puerto Rico, Turks and Caicos Islands, Trinidad and Tobago, the United States, Saint Vincent and the Grenadines, the British Virgin Islands, and the US Virgin Islands.",
        structured_answer => {
            input     => ['+1'],
            operation => 'international calling code',
            result    => qr/^Antigua.* US Virgin Islands$/,
        }
    ),
    "calling code +7" => test_zci(
        "+7 $txt the Russian Federation and Kazakhstan.",
        structured_answer => {
            input     => ['+7'],
            operation => 'international calling code',
            result    => 'the Russian Federation and Kazakhstan'
        }
    ),
    "calling code for russia" => test_zci(
        "+7 $txt the Russian Federation.",
        structured_answer => {
            input     => ['the Russian Federation'],
            operation => 'international calling code',
            result    => '+7'
        }
    ),
    "dial in code to the Russian Federation" => test_zci(
        "+7 $txt the Russian Federation.",
        structured_answer => {
            input     => ['the Russian Federation'],
            operation => 'international calling code',
            result    => '+7'
        }
    ),
    "calling code for south korea" => test_zci(
        "+82 $txt the Republic of Korea.",
        structured_answer => {
            input     => ['the Republic of Korea'],
            operation => 'international calling code',
            result    => '+82'
        }
    ),
    "calling code for the republic of korea" => test_zci(
        "+82 $txt the Republic of Korea.",
        structured_answer => {
            input     => ['the Republic of Korea'],
            operation => 'international calling code',
            result    => '+82'
        }
    ),
    "calling code for north korea" => test_zci(
        "+850 $txt the Democratic People's Republic of Korea.",
        structured_answer => {
            input     => ['the Democratic People\'s Republic of Korea'],
            operation => 'international calling code',
            result    => '+850'
        }
    ),
    "calling code for the democratic people's republic of korea" => test_zci(
        "+850 $txt the Democratic People's Republic of Korea.",
        structured_answer => {
            input     => ['the Democratic People\'s Republic of Korea'],
            operation => 'international calling code',
            result    => '+850'
        }
    ),
    # Properly negative
    'country code for the netherlands' => undef,
    'country code for north korea'     => undef,
    'country code +850'                => undef,
    "calling code for the moon"        => undef,
    "calling code +3boop"              => undef,
);

done_testing;
