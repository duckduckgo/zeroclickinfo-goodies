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
        "calling code 55"         => test_zci("+55 $txt Brazil."),
        "dialing code brazil"     => test_zci("+55 $txt Brazil."),
        "dialing code +55"        => test_zci("+55 $txt Brazil."),
        "country calling code 55" => test_zci("+55 $txt Brazil."),
        # Other working queries.
        "calling code for the moon"   => undef,
        "calling code +3boop"         => undef,
        "calling code for the sudan"  => test_zci("+249 $txt Sudan."),
        "calling code for vatican"    => test_zci("+379 $txt the Holy See (Vatican City State)."),
        "379 calling code vatican"    => test_zci("+379 $txt the Holy See (Vatican City State)."),
        "vatican calling code 379"    => test_zci("+379 $txt the Holy See (Vatican City State)."),
        "international calling code brazil"         => test_zci("+55 $txt Brazil."),
        "calling code 55 Brazil"      => test_zci("+55 $txt Brazil."),
        "calling code for Brazil +55" => test_zci("+55 $txt Brazil."),
        "calling code +55 for Brazil" => test_zci("+55 $txt Brazil."),
        "Brazil calling code +55"     => test_zci("+55 $txt Brazil."),
        "+55 calling code for Brazil" => test_zci("+55 $txt Brazil."),
        "calling code 65"             => test_zci("+65 $txt Singapore."),
        "calling code +65"            => test_zci("+65 $txt Singapore."),
        "dialing code +65"            => test_zci("+65 $txt Singapore."),
        "dial-in code +65"            => test_zci("+65 $txt Singapore."),
        "calling code for Singapore"  => test_zci("+65 $txt Singapore."),
        "international dial-in codes for Singapore"  => test_zci("+65 $txt Singapore."),
        "dialing code Singapore"      => test_zci("+65 $txt Singapore."),
        "dialing code for Singapore"  => test_zci("+65 $txt Singapore."),
        "dialing code for UK"         => test_zci("+44 $txt the United Kingdom."),
        "calling code for the UK"     => test_zci("+44 $txt the United Kingdom."),
        "uk calling code"             => test_zci("+44 $txt the United Kingdom."),
        "gb calling code"             => test_zci("+44 $txt the United Kingdom."),
        "calling code for antigua"    => test_zci("+1 $txt Antigua and Barbuda."),
        "calling code for barbuda"    => test_zci("+1 $txt Antigua and Barbuda."),
        "calling code for trinidad"   => test_zci("+1 $txt Trinidad and Tobago."),
        "calling code for tobago"     => test_zci("+1 $txt Trinidad and Tobago."),
        "dialing code for US"         => test_zci("+1 $txt the United States."),
        "calling code for america"    => test_zci("+1 $txt the United States."),
        "calling code +1"             => test_zci("+1 $txt Antigua and Barbuda, Anguilla, American Samoa, Barbados, Bermuda, the Bahamas, Canada, Dominica, the Dominican Republic, Grenada, Guam, Jamaica, Saint Lucia, Saint Kitts and Nevis, the Cayman Islands, the Northern Mariana Islands, Montserrat, Puerto Rico, Turks and Caicos Islands, Trinidad and Tobago, the United States, Saint Vincent and the Grenadines, the British Virgin Islands, and the US Virgin Islands."),
        "calling code +7"             => test_zci("+7 $txt the Russian Federation and Kazakhstan."),
        "calling code for russia"     => test_zci("+7 $txt the Russian Federation."),
        "dial in code to the Russian Federation" => test_zci("+7 $txt the Russian Federation."),
        "calling code for south korea"           => test_zci("+82 $txt the Republic of Korea."),
        "calling code for the republic of korea" => test_zci("+82 $txt the Republic of Korea."),
        "calling code for north korea"           => test_zci("+850 $txt the Democratic People's Republic of Korea."),
        "calling code for the democratic people's republic of korea" => test_zci("+850 $txt the Democratic People's Republic of Korea."),
        # Properly negative
        'country code for the netherlands' => undef,
        'country code for north korea'     => undef,
        'country code +850'                => undef,
);

done_testing;
