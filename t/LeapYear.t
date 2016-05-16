#!/usr/bin/env perl

use strict;
use warnings;

use Test::MockTime qw( :all );
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'leap_year';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::LeapYear
    )],
    'was 2012 a leap year' => test_zci('Yes! 2012 was a leap year',
    structured_answer => {
        data => {
            subtitle => undef,
            title => "Yes! 2012 was a leap year"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'will 3012 be a leap year' => test_zci('Yes! 3012 will be a leap year',
    structured_answer => {
        data => {
            subtitle => undef,
            title => "Yes! 3012 will be a leap year"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'was 1 bce a leap year' => test_zci('No. 1 BCE was not a leap year',
    structured_answer => {
        data => {
            subtitle => undef,
            title => "No. 1 BCE was not a leap year"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'leap years after 2005' => test_zci('The 5 leap years after 2005 are 2008, 2012, 2016, 2020, 2024',
    structured_answer => {
        data => {
            subtitle => "The 5 leap years after 2005",
            title => "2008, 2012, 2016, 2020, 2024"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'leap years before 2 bc' => test_zci('The 5 leap years before 2 BCE are 4 BCE, 8 BCE, 12 BCE, 16 BCE, 20 BCE',
    structured_answer => {
        data => {
            subtitle => "The 5 leap years before 2 BCE",
            title => "4 BCE, 8 BCE, 12 BCE, 16 BCE, 20 BCE"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    })
);

set_fixed_time("2014-12-01T00:00:00");
ddg_goodie_test(
    [qw(
        DDG::Goodie::LeapYear
    )],
    'is it a leap year?' => test_zci('No. 2014 is not a leap year',
    structured_answer => {
        data => {
            subtitle => undef,
            title => "No. 2014 is not a leap year"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'when were the last 50 leap years' => test_zci('The last 50 leap years were 2012, 2008, 2004, 2000, 1996, 1992, 1988, 1984, 1980, 1976, 1972, 1968, 1964, 1960, 1956, 1952, 1948, 1944, 1940, 1936, 1932, 1928, 1924, 1920, 1916, 1912, 1908, 1904, 1896, 1892, 1888, 1884, 1880, 1876, 1872, 1868, 1864, 1860, 1856, 1852, 1848, 1844, 1840, 1836, 1832, 1828, 1824, 1820, 1816, 1812',
    structured_answer => {
        data => {
            subtitle => "The last 50 leap years",
            title => "2012, 2008, 2004, 2000, 1996, 1992, 1988, 1984, 1980, 1976, 1972, 1968, 1964, 1960, 1956, 1952, 1948, 1944, 1940, 1936, 1932, 1928, 1924, 1920, 1916, 1912, 1908, 1904, 1896, 1892, 1888, 1884, 1880, 1876, 1872, 1868, 1864, 1860, 1856, 1852, 1848, 1844, 1840, 1836, 1832, 1828, 1824, 1820, 1816, 1812",
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    })
);
restore_time();
set_fixed_time("2015-12-01T00:00:00");
ddg_goodie_test(
    [qw(
        DDG::Goodie::LeapYear
    )],
    'is it a leap year?' => test_zci('No. 2015 is not a leap year',
    structured_answer => {
        data => {
            title => 'No. 2015 is not a leap year',
            subtitle => undef
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    })
);
restore_time();
set_fixed_time("2012-12-01T00:00:00");
ddg_goodie_test(
    [qw(
        DDG::Goodie::LeapYear
    )],
    'is it a leap year?' => test_zci('Yes! 2012 is a leap year',
    structured_answer => {
        data => {
            title => 'Yes! 2012 is a leap year',
            subtitle => undef
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    })
);
restore_time();

done_testing();
