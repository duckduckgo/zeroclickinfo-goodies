#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => 'days_between';
zci is_cached   => 0;

my $test_inclusive = ", inclusive";

sub build_structured_answer{
    my($startDate, $endDate, $daysBetween, $inclusive) = @_;
    return "There are $daysBetween days between $startDate and $endDate$inclusive",
    structured_answer => {
        data => {
            title    => $daysBetween,
            subtitle => "Days between$inclusive $startDate - $endDate"
        },
        templates => {
            group => "text"
        }
    }
}

sub build_test{ test_zci(build_structured_answer(@_))}

set_fixed_time('2016-08-03T22:36:00');

ddg_goodie_test(
    [qw( DDG::Goodie::DaysBetween)],
    'days between today and tomorrow'                            => build_test('03 Aug 2016', '04 Aug 2016', 1, ''),
    'days between jan 1 and jan 15 inclusive'                    => build_test('01 Jan 2016', '15 Jan 2016', 15, $test_inclusive),
    'days between jan 1 and 15th feb'                            => build_test('01 Jan 2016', '15 Feb 2016', 45, ''),
    'how many days between feb 2 and feb 17'                     => build_test('02 Feb 2016', '17 Feb 2016', 15, ''),
    'days between 2000-01-01 2001-01-01'                         => build_test('01 Jan 2000', '01 Jan 2001', 366, '' ),
    'days between 2000-01-01 and 2001-01-01 inclusive'           => build_test('01 Jan 2000', '01 Jan 2001',367, $test_inclusive),
    'daysbetween 2005-03-04 and 2020-11-08'                      => build_test('04 Mar 2005', '08 Nov 2020', 5728, ''),
    'days_between 2005-03-14 and 2003-01-02'                     => build_test('02 Jan 2003', '14 Mar 2005', 802, ''),
    'days_between 2005-03-14 and 2003-01-02 inclusive'           => build_test('02 Jan 2003', '14 Mar 2005', 803, $test_inclusive),
    'days between 2001-01-31 2001-01-31'                         => build_test('31 Jan 2001', '31 Jan 2001', 0, ''),
    'days between 2001-01-31 2001-01-31 inclusive'               => build_test('31 Jan 2001', '31 Jan 2001', 1, $test_inclusive),
    'number of days from 2015-02-02 and 2016-02-02'              => build_test('02 Feb 2015', '02 Feb 2016', 365, ''),
    'number of days from 2015-02-02 and 2016-02-02 inclusive'    => build_test('02 Feb 2015', '02 Feb 2016', 366, $test_inclusive),
    'number of days between 2014-02-02 and 2015-02-02'           => build_test('02 Feb 2014', '02 Feb 2015', 365, ''),
    'days since 2016-07-31'                                      => build_test('31 Jul 2016', '03 Aug 2016', 3, ''),    
    'days until tomorrow'                                        => build_test('03 Aug 2016', '04 Aug 2016', 1, ''),
    'the day before yesterday'                                   => undef,
    'weekdays between 2015-02-02 and 2016-02-02'                 => undef,    
    'number of days between 2014-02-02 and 2015-02-02 inclusive' => build_test('02 Feb 2014', '02 Feb 2015', 366, $test_inclusive),
    'days since 2016-07-31'                                      => build_test('31 Jul 2016', '03 Aug 2016', 3, ''),
    'days until 2017-09-05'                                      => build_test('03 Aug 2016', '05 Sep 2017', 398, ''),
    'days between jan 1 2012 and jan 1 123456'                   => undef,
);

restore_time();
done_testing;
