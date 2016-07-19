#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => 'days_between';
zci is_cached   => 1;

<<<<<<< HEAD
ddg_goodie_test(
    [qw( DDG::Goodie::DaysBetween)],
#     'days between 01/01/2000 01/01/2001' => test_zci(
#         'There are 366 days between 01 Jan 2000 and 01 Jan 2001.',
#         structured_answer => {
#             input     => ['01 Jan 2000', '01 Jan 2001'],
#             operation => 'Days between',
#             result    => 366
#         },
#     ),
#     'days between 1/1/2000 and 1/1/2001 inclusive' => test_zci(
#         'There are 367 days between 01 Jan 2000 and 01 Jan 2001, inclusive.',
#         structured_answer => {
#             input     => ['01 Jan 2000', '01 Jan 2001'],
#             operation => 'Days between, inclusive',
#             result    => 367
#         },
#     ),
#     'daysbetween 03/4/2005 and 11/8/2020' => test_zci(
#         'There are 5728 days between 04 Mar 2005 and 08 Nov 2020.',
#         structured_answer => {
#             input     => ['04 Mar 2005', '08 Nov 2020'],
#             operation => 'Days between',
#             result    => 5728
#         },
#     ),
#     'days_between 3/14/2005 and 1/2/2003' => test_zci(
#         'There are 802 days between 02 Jan 2003 and 14 Mar 2005.',
#         structured_answer => {
#             input     => ['02 Jan 2003', '14 Mar 2005'],
#             operation => 'Days between',
#             result    => 802
#         },
#     ),
#     'days between 01/31/2000 01/31/2001' => test_zci(
#         'There are 366 days between 31 Jan 2000 and 31 Jan 2001.',
#         structured_answer => {
#             input     => ['31 Jan 2000', '31 Jan 2001'],
#             operation => 'Days between',
#             result    => 366
#         },
#     ),
#     'days between 01/31/2000 01/31/2001 inclusive' => test_zci(
#         'There are 367 days between 31 Jan 2000 and 31 Jan 2001, inclusive.',
#         structured_answer => {
#             input     => ['31 Jan 2000', '31 Jan 2001'],
#             operation => 'Days between, inclusive',
#             result    => 367
#         },
#     ),
#     'days between January 31st, 2000 and 31-Jan-2001 inclusive' => test_zci(
#         'There are 367 days between 31 Jan 2000 and 31 Jan 2001, inclusive.',
#         structured_answer => {
#             input     => ['31 Jan 2000', '31 Jan 2001'],
#             operation => 'Days between, inclusive',
#             result    => 367
#         },
#     ),
#     'days between jan 1 2012 and jan 1 1234' => test_zci(
#         "There are 284158 days between 01 Jan 1234 and 01 Jan 2012.",
#         structured_answer => {
#             input     => ['01 Jan 1234', '01 Jan 2012'],
#             operation => 'Days between',
#             result    => 284158
#         },
#     ),
#     'days between jan 1 and jan 15 inclusive' => test_zci(
#         re(qr/^There are 15 days between.+inclusive\.$/),
#         structured_answer => {
#             input     => ignore(),
#             operation => 'Days between, inclusive',
#             result    => 15
#         },
#     ),
#     'days between jan 1 and 15th feb' => test_zci(
#         re(qr/^There are 45 days between.+and 15 Feb [0-9]{4}\.$/),
#         structured_answer => {
#             input     => ignore(),
#             operation => 'Days between',
#             result    => 45
#         },
#     ),
#        'number of days between jan 1 and 15th feb' => test_zci(
#         re(qr/^There are 45 days between.+and 15 Feb [0-9]{4}\.$/),
#         structured_answer => {
#             input     => ignore(),
#             operation => 'Days between',
#             result    => 45
#         },
#     ),
#     'number of days from jan 1 and 15th feb' => test_zci(
#         re(qr/^There are 45 days between.+and 15 Feb [0-9]{4}\.$/),
#         structured_answer => {
#             input     => ignore(),
#             operation => 'Days between',
#             result    => 45
#         },
#     ),
#     'days from jan 1 and 15th feb' => test_zci(
#         re(qr/^There are 45 days between.+and 15 Feb [0-9]{4}\.$/),
#         structured_answer => {
#             input     => ignore(),
#             operation => 'Days between',
#             result    => 45
#         },
#     ),
#     'days between today and tomorrow' => test_zci(
#         re(qr/^There are 1 days between.+ and.+\.$/),
#         structured_answer => {
#             input     => ignore(),
#             operation => 'Days between',
#             result    => 1
#         },
#     ),
#     'how many days between feb 2 and feb 17' => test_zci(
#         re(qr/^There are 15 days between.+ and.+\.$/),
#         structured_answer => {
#             input     => ignore(),
#             operation => 'Days between',
#             result    => 15
#         },
#     ),
#     'days between jan 1 2012 and jan 1 123456' => undef,
# );
#
# set_fixed_time('2015-07-14T22:36:00');
#
# ddg_goodie_test(
#     [qw( DDG::Goodie::DaysBetween)],
#     'days between 22nd may and today' => test_zci(
#         'There are 53 days between 22 May 2015 and 14 Jul 2015.',
#         structured_answer => {
#             input     => ['22 May 2015', '14 Jul 2015'],
#             operation => 'Days between',
#             result    => 53
#         },
#     ),
=======
sub build_structured_answer{
    my($startDate, $endDate, $daysBetween, $inclusive) = @_;
    return "There are $daysBetween days between $startDate and $endDate$inclusive.",
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

set_fixed_time('2016-07-14T22:36:00');

my $test_inclusive = ", inclusive";

ddg_goodie_test(
    [qw( DDG::Goodie::DaysBetween)],
    'days between today and tomorrow'                            => build_test('14 Jul 2016', '15 Jul 2016', 1, ''),
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
    'number of days between 2014-02-02 and 2015-02-02 inclusive' => build_test('02 Feb 2014', '02 Feb 2015', 366, $test_inclusive),
    'days between jan 1 2012 and jan 1 123456'                   => undef
>>>>>>> 479814bd70f212d34a383181d710a72fa41d325f
);

restore_time();
done_testing;
