#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'date_conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::AltCalendars
        )],
        'heisei 25' => test_zci('Heisei 25 is equivalent to 2013 in the Gregorian Calendar', html => 'Heisei 25 is equivalent to 2013 in the Gregorian Calendar<br><a href="https://en.wikipedia.org/wiki/Heisei_period">More at Wikipedia</a>'),
        'shouwa 39' => test_zci('Shouwa 39 is equivalent to 1964 in the Gregorian Calendar', html => 'Shouwa 39 is equivalent to 1964 in the Gregorian Calendar<br><a href="https://en.wikipedia.org/wiki/Showa_period">More at Wikipedia</a>'),
        'taisho 11' => test_zci('Taisho 11 is equivalent to 1922 in the Gregorian Calendar', html => 'Taisho 11 is equivalent to 1922 in the Gregorian Calendar<br><a href="https://en.wikipedia.org/wiki/Taisho_period">More at Wikipedia</a>'),
        'meiji 1' => test_zci('Meiji 1 is equivalent to 1868 in the Gregorian Calendar', html => 'Meiji 1 is equivalent to 1868 in the Gregorian Calendar<br><a href="https://en.wikipedia.org/wiki/Meiji_period">More at Wikipedia</a>'),
        'minguo 50' => test_zci('Minguo 50 is equivalent to 1961 in the Gregorian Calendar', html => 'Minguo 50 is equivalent to 1961 in the Gregorian Calendar<br><a href="https://en.wikipedia.org/wiki/Minguo_calendar">More at Wikipedia</a>'),
        'juche 07' => test_zci('Juche 07 is equivalent to 1918 in the Gregorian Calendar', html => 'Juche 07 is equivalent to 1918 in the Gregorian Calendar<br><a href="https://en.wikipedia.org/wiki/North_Korean_calendar">More at Wikipedia</a>'),
        'Heisei 12 was a leap year' => test_zci('2000 was a leap year (Heisei 12 is equivalent to 2000 in the Gregorian Calendar)', html => '2000 was a leap year (Heisei 12 is equivalent to 2000 in the Gregorian Calendar)<br><a href="https://en.wikipedia.org/wiki/Heisei_period">More at Wikipedia</a>'),
        'it\'s heisei 25 now' => test_zci('it\'s 2013 now (Heisei 25 is equivalent to 2013 in the Gregorian Calendar)', html => 'it\'s 2013 now (Heisei 25 is equivalent to 2013 in the Gregorian Calendar)<br><a href="https://en.wikipedia.org/wiki/Heisei_period">More at Wikipedia</a>'),
        'January 1st Meiji 33' => test_zci('January 1st 1900 (Meiji 33 is equivalent to 1900 in the Gregorian Calendar)', html => 'January 1st 1900 (Meiji 33 is equivalent to 1900 in the Gregorian Calendar)<br><a href="https://en.wikipedia.org/wiki/Meiji_period">More at Wikipedia</a>'),
        'heisei 24' => test_zci('Heisei 24 is equivalent to 2012 in the Gregorian Calendar', html => 'Heisei 24 is equivalent to 2012 in the Gregorian Calendar<br><a href="https://en.wikipedia.org/wiki/Heisei_period">More at Wikipedia</a>'),
);

done_testing;
