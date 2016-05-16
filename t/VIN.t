#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'vin';
zci is_cached => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::VIN )],
        '1g8gg35m1g7123101' => test_zci(
        "Decode VIN (1G8GG35M1G7123101) at Decode This: http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101",
        structured_answer => {
            data => {
                title => "Vehicle Identification Number: 1G8GG35M1G7123101",
                href => "http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101"
            },
            templates => {
                group => 'text',
                options => {
                    subtitle_content => "DDH.vin.subtitle"
                }
            }
        }
    ),
        'vin 1g8gg35m1g7123101' => test_zci(
        "Decode VIN (1G8GG35M1G7123101) at Decode This: http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101",
        structured_answer => {
            data => {
                title => "Vehicle Identification Number: 1G8GG35M1G7123101",
                href => "http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101"
            },
            templates => {
                group => 'text',
                options => {
                    subtitle_content => "DDH.vin.subtitle"
                }
            }
        }
    ),
        '1g8gg35m1g7123101 vehicle identification number' => test_zci(
        "Decode VIN (1G8GG35M1G7123101) at Decode This: http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101",
        structured_answer => {
            data => {
                title => "Vehicle Identification Number: 1G8GG35M1G7123101",
                href => "http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101"
            },
            templates => {
                group => 'text',
                options => {
                    subtitle_content => "DDH.vin.subtitle"
                }
            }
        }
    ),
        '1g8gg35m1g7123101 tracking' => test_zci(
        "Decode VIN (1G8GG35M1G7123101) at Decode This: http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101",
        structured_answer => {
            data => {
                title => "Vehicle Identification Number: 1G8GG35M1G7123101",
                href => "http://www.decodethis.com/VIN-Decoded/vin/1G8GG35M1G7123101"
            },
            templates => {
                group => 'text',
                options => {
                    subtitle_content => "DDH.vin.subtitle"
                }
            }
        }
    ),
);

done_testing;
