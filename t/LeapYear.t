#!/usr/bin/env perl

use strict;
use warnings;

use Test::MockTime qw( :all );
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'leap_year';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::LeapYear
    )],
    'was 2012 a leap year' => test_zci('Yes! 2012 CE was a leap year',
    structured_answer => {
        id => "leap_year",
        name => "Answer",
        data => {
            subtitle => undef,
            title => "Yes! 2012 CE was a leap year"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'will 3012 be a leap year' => test_zci('Yes! 3012 CE will be a leap year',
    structured_answer => {
        id => "leap_year",
        name => "Answer",
        data => {
            subtitle => undef,
            title => "Yes! 3012 CE will be a leap year"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'was 1 bce a leap year' => test_zci('No. 1 BCE was not a leap year',
    structured_answer => {
        id => "leap_year",
        name => "Answer",
        data => {
            subtitle => undef,
            title => "No. 1 BCE was not a leap year"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'leap years after 2005' => test_zci('The 5 leap years after 2005 CE are 2008 CE, 2012 CE, 2016 CE, 2020 CE, 2024 CE',
    structured_answer => {
        id => "leap_year",
        name => "Answer",
        data => {
            subtitle => "The 5 leap years after 2005 CE",
            title => "2008 CE, 2012 CE, 2016 CE, 2020 CE, 2024 CE"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'leap years before 2 bc' => test_zci('The 5 leap years before 2 BCE are 4 BCE, 8 BCE, 12 BCE, 16 BCE, 20 BCE',
    structured_answer => {
        id => "leap_year",
        name => "Answer",
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
    'is it a leap year?' => test_zci('No. 2014 CE is not a leap year',
    structured_answer => {
        id => "leap_year",
        name => "Answer",
        data => {
            subtitle => undef,
            title => "No. 2014 CE is not a leap year"
        },
        templates => {
            group => "text",
            moreAt => 0
        }
    }),
    'when were the last 50 leap years' => test_zci('The last 50 leap years were 2012 CE, 2008 CE, 2004 CE, 2000 CE, 1996 CE, 1992 CE, 1988 CE, 1984 CE, 1980 CE, 1976 CE, 1972 CE, 1968 CE, 1964 CE, 1960 CE, 1956 CE, 1952 CE, 1948 CE, 1944 CE, 1940 CE, 1936 CE, 1932 CE, 1928 CE, 1924 CE, 1920 CE, 1916 CE, 1912 CE, 1908 CE, 1904 CE, 1896 CE, 1892 CE, 1888 CE, 1884 CE, 1880 CE, 1876 CE, 1872 CE, 1868 CE, 1864 CE, 1860 CE, 1856 CE, 1852 CE, 1848 CE, 1844 CE, 1840 CE, 1836 CE, 1832 CE, 1828 CE, 1824 CE, 1820 CE, 1816 CE, 1812 CE',
    structured_answer => {
        id => "leap_year",
        name => "Answer",
        data => {
            subtitle => "The last 50 leap years",
            title => "2012 CE, 2008 CE, 2004 CE, 2000 CE, 1996 CE, 1992 CE, 1988 CE, 1984 CE, 1980 CE, 1976 CE, 1972 CE, 1968 CE, 1964 CE, 1960 CE, 1956 CE, 1952 CE, 1948 CE, 1944 CE, 1940 CE, 1936 CE, 1932 CE, 1928 CE, 1924 CE, 1920 CE, 1916 CE, 1912 CE, 1908 CE, 1904 CE, 1896 CE, 1892 CE, 1888 CE, 1884 CE, 1880 CE, 1876 CE, 1872 CE, 1868 CE, 1864 CE, 1860 CE, 1856 CE, 1852 CE, 1848 CE, 1844 CE, 1840 CE, 1836 CE, 1832 CE, 1828 CE, 1824 CE, 1820 CE, 1816 CE, 1812 CE",
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
    'is it a leap year?' => test_zci('No. 2015 CE is not a leap year',
    structured_answer => {
        id => "leap_year",
        name => "Answer",
        data => {
            title => 'No. 2015 CE is not a leap year',
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
    'is it a leap year?' => test_zci('Yes! 2012 CE is a leap year',
    structured_answer => {
        id => "leap_year",
        name => "Answer",
        data => {
            title => 'Yes! 2012 CE is a leap year',
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
