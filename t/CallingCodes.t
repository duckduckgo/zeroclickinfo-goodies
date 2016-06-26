#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "calling_codes";
zci is_cached   => 1;

sub build_structured_answer_to_country {
    my ($country_list, $dialing_code) = @_;
    return $dialing_code . ' is the international calling code for ' . $country_list . '.',
        structured_answer => {
            data => {
                title    => $country_list,
                subtitle => 'International calling code: ' .$dialing_code
            },
            templates => {
                group => 'text'
            }
    };
}

sub build_structured_answer_to_code {
    my ($country_list, $dialing_code) = @_;
    return $dialing_code . ' is the international calling code for ' . $country_list . '.',
        structured_answer => {
            data => {
                title    => $dialing_code,
                subtitle => 'International calling code: ' . $country_list
            },
            templates => {
                group => 'text'
            }
    };
}

sub build_test_to_country { test_zci(build_structured_answer_to_country(@_)) }
sub build_test_to_code { test_zci(build_structured_answer_to_code(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::CallingCodes )],
    # Example queries
    "calling code 55"         => build_test_to_country('Brazil', '+55'),
    "dialing code brazil"     => build_test_to_code('Brazil', '+55'),
    "dialing code +55"        => build_test_to_country('Brazil', '+55'),
    "country calling code 55" => build_test_to_country('Brazil', '+55'),
    # Other working queries.
    "calling code for the sudan"             => build_test_to_code('Sudan', '+249'),
    "calling code for vatican"               => build_test_to_code('the Holy See (Vatican City State)', '+379'),
    "379 calling code vatican"               => build_test_to_country('the Holy See (Vatican City State)', '+379'),
    "vatican calling code 379"               => build_test_to_code('the Holy See (Vatican City State)', '+379'),
    "country dial in code brazil"            => build_test_to_code('Brazil', '+55'),
    "calling code 55 Brazil"                 => build_test_to_country('Brazil', '+55'),
    "calling code for Brazil +55"            => build_test_to_code('Brazil', '+55'),
    "calling code +55 for Brazil"            => build_test_to_country('Brazil', '+55'),
    "Brazil calling code +55"                => build_test_to_code('Brazil', '+55'),
    "+55 calling code for Brazil"            => build_test_to_country('Brazil', '+55'),
    "calling code 65"                        => build_test_to_country('Singapore', '+65'),
    "calling code +65"                       => build_test_to_country('Singapore', '+65'),
    "dialing code +65"                       => build_test_to_country('Singapore', '+65'),
    "international dial-in code +65"         => build_test_to_country('Singapore', '+65'),
    "calling code for Singapore"             => build_test_to_code('Singapore', '+65'),
    "country calling code for Singapore"     => build_test_to_code('Singapore', '+65'),
    "dialing code Singapore"                 => build_test_to_code('Singapore', '+65'),
    "dialing code for Singapore"             => build_test_to_code('Singapore', '+65'),
    "dialing code for UK"                    => build_test_to_code('the United Kingdom', '+44'),
    "calling code for the UK"                => build_test_to_code('the United Kingdom', '+44'),
    "uk calling code"                        => build_test_to_code('the United Kingdom', '+44'),
    "gb calling code"                        => build_test_to_code('the United Kingdom', '+44'),
    "calling code for antigua"               => build_test_to_code('Antigua and Barbuda', '+1'),
    "calling code for barbuda"               => build_test_to_code('Antigua and Barbuda', '+1'),
    "calling code for trinidad"              => build_test_to_code('Trinidad and Tobago', '+1'),
    "calling code for tobago"                => build_test_to_code('Trinidad and Tobago', '+1'),
    "dialing code for US"                    => build_test_to_code('the United States', '+1'),
    "calling code for america"               => build_test_to_code('the United States', '+1'),
    "dial in code +1"                        => build_test_to_country('Antigua and Barbuda, Anguilla, American Samoa, Barbados, Bermuda, the Bahamas, Canada, Dominica, the Dominican Republic, Grenada, Guam, Jamaica, Saint Lucia, Saint Kitts and Nevis, the Cayman Islands, the Northern Mariana Islands, Montserrat, Puerto Rico, Turks and Caicos Islands, Trinidad and Tobago, the United States, Saint Vincent and the Grenadines, the British Virgin Islands, and the US Virgin Islands', '+1'),
    "calling code +7"                        => build_test_to_country('the Russian Federation and Kazakhstan', '+7'),
    "calling code for russia"                => build_test_to_code('the Russian Federation', '+7'),
    "dial in code to the Russian Federation" => build_test_to_code('the Russian Federation', '+7'),
    "calling code for south korea"           => build_test_to_code('the Republic of Korea', '+82'),
    "calling code for the republic of korea" => build_test_to_code('the Republic of Korea', '+82'),
    "calling code for north korea"           => build_test_to_code('the Democratic People\'s Republic of Korea', '+850'),
    "calling code for the democratic people's republic of korea" => build_test_to_code('the Democratic People\'s Republic of Korea', '+850'),
    # Properly negative
    'country code for the netherlands' => undef,
    'country code for north korea'     => undef,
    'country code +850'                => undef,
    "calling code for the moon"        => undef,
    "calling code +3boop"              => undef,
    "calling code 599"                 => undef,
);

done_testing;
