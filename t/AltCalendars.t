#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'date_conversion';
zci is_cached => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::AltCalendars )],
    'heisei 25' => test_zci(
        'Heisei 25 is equivalent to 2013 in the Gregorian Calendar',
        structured_answer => {
            input     => ['Heisei 25'],
            operation => 'Gregorian conversion of Heisei 25',
            result    => 'Heisei 25 is equivalent to 2013 in the Gregorian Calendar&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/Heisei_period&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
    'shouwa 39' => test_zci(
        'Shouwa 39 is equivalent to 1964 in the Gregorian Calendar',
        structured_answer => {
            input     => ['Shouwa 39'],
            operation => 'Gregorian conversion of Shouwa 39',
            result    => 'Shouwa 39 is equivalent to 1964 in the Gregorian Calendar&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/Showa_period&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
    'taisho 11' => test_zci(
        'Taisho 11 is equivalent to 1922 in the Gregorian Calendar',
        structured_answer => {
            input     => ['Taisho 11'],
            operation => 'Gregorian conversion of Taisho 11',
            result    => 'Taisho 11 is equivalent to 1922 in the Gregorian Calendar&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/Taisho_period&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
    'meiji 1' => test_zci(
        'Meiji 1 is equivalent to 1868 in the Gregorian Calendar',
        structured_answer => {
            input     => ['Meiji 1'],
            operation => 'Gregorian conversion of Meiji 1',
            result    => 'Meiji 1 is equivalent to 1868 in the Gregorian Calendar&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/Meiji_period&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
    'minguo 50' => test_zci(
        'Minguo 50 is equivalent to 1961 in the Gregorian Calendar',
        structured_answer => {
            input     => ['Minguo 50'],
            operation => 'Gregorian conversion of Minguo 50',
            result    => 'Minguo 50 is equivalent to 1961 in the Gregorian Calendar&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/Minguo_calendar&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
    'juche 07' => test_zci(
        'Juche 07 is equivalent to 1918 in the Gregorian Calendar',
        structured_answer => {
            input     => ['Juche 07'],
            operation => 'Gregorian conversion of Juche 07',
            result    => 'Juche 07 is equivalent to 1918 in the Gregorian Calendar&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/North_Korean_calendar&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
    'Heisei 12 was a leap year' => test_zci(
        '2000 was a leap year (Heisei 12 is equivalent to 2000 in the Gregorian Calendar)',
        structured_answer => {
            input     => ['Heisei 12'],
            operation => 'Gregorian conversion of Heisei 12',
            result    => '2000 was a leap year (Heisei 12 is equivalent to 2000 in the Gregorian Calendar)&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/Heisei_period&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
    'it\'s heisei 25 now' => test_zci(
        'it\'s 2013 now (Heisei 25 is equivalent to 2013 in the Gregorian Calendar)',
        structured_answer => {
            input     => ['Heisei 25'],
            operation => 'Gregorian conversion of Heisei 25',
            result    => 'it&#39;s 2013 now (Heisei 25 is equivalent to 2013 in the Gregorian Calendar)&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/Heisei_period&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
    'January 1st Meiji 33' => test_zci(
        'January 1st 1900 (Meiji 33 is equivalent to 1900 in the Gregorian Calendar)',
        structured_answer => {
            input     => ['Meiji 33'],
            operation => 'Gregorian conversion of Meiji 33',
            result    => 'January 1st 1900 (Meiji 33 is equivalent to 1900 in the Gregorian Calendar)&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/Meiji_period&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
    'heisei 24' => test_zci(
        'Heisei 24 is equivalent to 2012 in the Gregorian Calendar',
        structured_answer => {
            input     => ['Heisei 24'],
            operation => 'Gregorian conversion of Heisei 24',
            result    => 'Heisei 24 is equivalent to 2012 in the Gregorian Calendar&lt;br&gt;&lt;a href=&quot;https://en.wikipedia.org/wiki/Heisei_period&quot;&gt;More at Wikipedia&lt;/a&gt;'
        }
    ),
);

done_testing;
