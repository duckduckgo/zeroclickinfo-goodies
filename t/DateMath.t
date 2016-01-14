#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::MockTime qw( :all );
use DDG::Test::Goodie;

zci answer_type => 'date_math';
zci is_cached   => 1;

sub build_structured_answer {
    my ($result, $input) = @_;
    return $result, structured_answer => {
        id   => 'date_math',
        name => 'Answer',
        data => {
            title    => "$result",
            subtitle => "$input",
        },
        templates => {
            group => 'text',
        },
    };
}

sub build_test { test_zci(build_structured_answer(@_)) }

my @overjan = ('02 Feb 2012', '01 Jan 2012 + 32 days');
my @first_sec = ('02 Jan 2012', '01 Jan 2012 + 1 day');

set_fixed_time("2014-03-12T10:00:00");

ddg_goodie_test([ qw( DDG::Goodie::DateMath ) ],
    # 2012 Jan tests
    'Jan 1 2012 plus 32 days'       => build_test(@overjan),
    'January 1 2012 plus 32 days'   => build_test(@overjan),
    'January 1, 2012 plus 32 days'  => build_test(@overjan),
    'January 1st 2012 plus 32 days' => build_test(@overjan),
    '32 days from January 1st 2012' => build_test(@overjan),
    # Relative (to today)
    'date January 1st'         => build_test('01 Jan 2014', 'january 1st'),
    '6 weeks ago'              => build_test('29 Jan 2014', '6 weeks ago'),
    '2 weeks from today'       => build_test('26 Mar 2014', '12 Mar 2014 + 2 weeks'),
    'in 3 weeks'               => build_test('02 Apr 2014', 'in 3 weeks'),
    'date today'               => build_test('12 Mar 2014', 'today'),
    'January 1st plus 32 days' => build_test('02 Feb 2014', '01 Jan 2014 + 32 days'),
    # Misc
    '1 jan 2014 plus 2 weeks' => build_test('15 Jan 2014', '01 Jan 2014 + 2 weeks'),
    # / form
    '1/1/2012 plus 32 days'   => build_test(@overjan),
    '1/1/2012 plus 5 weeks'   => build_test('05 Feb 2012', '01 Jan 2012 + 5 weeks'),
    '1/1/2012 PlUs 5 months'  => build_test('01 Jun 2012', '01 Jan 2012 + 5 months'),
    '1/1/2012 PLUS 5 years'   => build_test('01 Jan 2017', '01 Jan 2012 + 5 years'),
    '1 day from 1/1/2012'     => build_test(@first_sec),
    '1/1/2012 plus 1 day'     => build_test(@first_sec),
    '1/1/2012 plus 1 days'    => build_test(@first_sec),
    '01/01/2012 + 1 day'      => build_test(@first_sec),
    '1/1/2012 minus ten days' => build_test('22 Dec 2011', '01 Jan 2012 - 10 days'),
    # Should not trigger
    'yesterday'  => undef,
    'today'      => undef,
    'five years' => undef,
    'two months' => undef,
    '2 months'   => undef,
    '5 years'    => undef,
);

done_testing;
