#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'calling_codes';

ddg_goodie_test(
        [qw( DDG::Goodie::CallingCodes )],
        'calling code for the moon'  => undef,
        'calling code +3boop'        => undef,
        'calling code 55'            => test_zci('+55 is the international calling code for Brazil.'),
        'country code brazil'        => test_zci('+55 is the international calling code for Brazil.'),
        'dialing code +55'           => test_zci('+55 is the international calling code for Brazil.'),
        'country calling code 55'    => test_zci('+55 is the international calling code for Brazil.'),
        'calling code 65'            => test_zci('+65 is the international calling code for Singapore.'),
        'calling code +65'           => test_zci('+65 is the international calling code for Singapore.'),
        'dialing code +65'           => test_zci('+65 is the international calling code for Singapore.'),
        'country code +65'           => test_zci('+65 is the international calling code for Singapore.'),
        'country code for Singapore' => test_zci('+65 is the international calling code for Singapore.'),
        'country code for Singapore' => test_zci('+65 is the international calling code for Singapore.'),
        'dialing code Singapore'     => test_zci('+65 is the international calling code for Singapore.'),
        'dialing code for Singapore' => test_zci('+65 is the international calling code for Singapore.'),
        'dialing code for US'        => test_zci('+1 is the international calling code for the United States.'),
        'calling code for america'   => test_zci('+1 is the international calling code for the United States.'),
        'dialing code for UK'        => test_zci('+44 is the international calling code for the United Kingdom.'),
        'calling code for the UK'    => test_zci('+44 is the international calling code for the United Kingdom.'),
        'uk calling code'            => test_zci('+44 is the international calling code for the United Kingdom.'),
        'gb calling code'            => test_zci('+44 is the international calling code for the United Kingdom.'),
        'country code +1'            => test_zci('+1 is the international calling code for Antigua and Barbuda, Anguilla, American Samoa, Barbados, Bermuda, The Bahamas, Canada, Dominica, the Dominican Republic, Grenada, Guam, Jamaica, Saint Lucia, Saint Kitts and Nevis, the Cayman Islands, the Northern Mariana Islands, Montserrat, Puerto Rico, Turks and Caicos Islands, Trinidad and Tobago, the United States, Saint Vincent and the Grenadines, the British Virgin Islands, and the US Virgin Islands.'),
        'calling code +7'            => test_zci('+7 is the international calling code for the Russian Federation and Kazakhstan.'),
        'calling code for russia'    => test_zci('+7 is the international calling code for the Russian Federation.'),
        'dial in code to the Russian Federation' => test_zci('+7 is the international calling code for the Russian Federation.'),
);

done_testing;
