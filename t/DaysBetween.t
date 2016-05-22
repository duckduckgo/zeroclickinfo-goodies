#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => 'days_between';
zci is_cached   => 1;

sub build_structured_answer{
    my($startDate, $endDate, $daysBetween, $inclusive) = @_;
    return "There are $daysBetween days between $startDate and $endDate $inclusive.",
    structured_answer => {
        data => {
            title    => $daysBetween,
            subtitle => "Days between $inclusive $startDate - $endDate"
        },
        templates => {
            group => "text"
        }
    }
}

sub build_test{ test_zci(build_structured_answer(@_))}

set_fixed_time('2016-07-14T22:36:00');

my $test_inclusive = ", inclusive";

ddg_goodie_test(
    [qw( DDG::Goodie::DaysBetween)],
    'days between 2000-01-01 2001-01-01'                        => build_test('01 Jan 2000', '01 Jan 2001', 366, '' ),
    'days between 2000-1-1 and 2001-1-1 inclusive'              => build_test('01 Jan 2000', '01 Jan 2001',367, $test_inclusive),
    'daysbetween 2005-03-4 and 2020-11-8'                       => build_test('04 Mar 2005', '08 Nov 2020', 5728, ''),
    'days_between 2005-3-14 and 2003-1-2'                       => build_test('02 Jan 2003', '14 Mar 2005', 802, ''),
    'days between 2000-01-31 2001-01-31'                        => build_test('31 Jan 2000', '31 Jan 2001', 366, ''),
    'days between 2000-01-31 2001-01-31 inclusive'              => build_test('31 Jan 2000', '31 Jan 2001', 367, $test_inclusive),
    'days between January 31st, 2000 and 31-Jan-2001 inclusive' => build_test('31 Jan 2000', '31 Jan 2001', 367, $test_inclusive),
    'days between jan 1 2012 and jan 1 1234'                    => build_test('01 Jan 1234', '01 Jan 2012', 284158, ''),
    'days between jan 1 and jan 15 inclusive'                   => build_test('01 Jan 2016', '15 Jan 2016', 15, $test_inclusive),
    'days between jan 1 and 15th feb'                           => build_test('01 Jan 2016', '15 Feb 2016', 45, ''),
    'days between today and tomorrow'                           => build_test('14 Jul 2016', '15 Jul 2016', 1, ''),
    'how many days between feb 2 and feb 17'                    => build_test('02 Feb 2016', '17 Feb 2016', 15, ''),
    'days between 22nd may and today'                           => build_test('22 May 2016', '14 Jul 2016', 53, ''),
    'days between jan 1 2012 and jan 1 123456'                  => undef
);

restore_time();
done_testing;
