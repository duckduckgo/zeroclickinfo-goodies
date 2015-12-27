#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DateTime;

zci answer_type => "day_of_week";
zci is_cached   => 1;

sub build_answer {
    my ($answer, $sub) = @_;
    $sub = '' unless $sub;

    return sprintf("Day of the Week: %s",$answer) , structured_answer => {
        id => 'day_of_week',
        name => 'Answer',
        data => {
            title => $answer,
            subtitle => "Day of the week for: $sub"
        },
        templates => {
            group => 'text',
            moreAt => 0
        }
    }
}


# my $dt = DateTime->now(time_zone => $loc->time_zone);
my $dt_today     = DateTime->now;
my $dt_tomorrow  = $dt_today->clone->add( days => 1 );
my $dt_yesterday = $dt_today->clone->subtract( days => 1 );

ddg_goodie_test(
    [qw( DDG::Goodie::DayOfWeek )],

    'day of week june 22 1907'   => test_zci( build_answer( 'Saturday', '22 Jun 1907' ) ),
    'day of week for 1/1/2012'   => test_zci( build_answer( 'Sunday',   '01 Jan 2012' ) ),
    'day of week for 01/01/2012' => test_zci( build_answer( 'Sunday',   '01 Jan 2012' ) ),

    'what day was 1/1/2005' => test_zci( build_answer( 'Saturday', '01 Jan 2005' ) ),
    '1/1/2005 was what day' => test_zci( build_answer( 'Saturday', '01 Jan 2005' ) ),

    'what day will 1/1/2025 be'          => test_zci( build_answer( 'Wednesday', '01 Jan 2025' ) ),
    'What day will November 23 2050 be?' => test_zci( build_answer( 'Wednesday', '23 Nov 2050' ) ),
    'What day will 23 November 2050 be?' => test_zci( build_answer( 'Wednesday', '23 Nov 2050' ) ),

    'day of week 1/12/2005' => test_zci( build_answer( 'Wednesday', '12 Jan 2005' ) ),
    'day of week 12/1/2005' => test_zci( build_answer( 'Thursday',  '01 Dec 2005' ) ),
    'day of week 13/1/2005' => test_zci( build_answer( 'Thursday',  '13 Jan 2005' ) ),

    'day of week today'     => test_zci( build_answer( $dt_today->day_name,     $dt_today->strftime("%d %b %Y") ) ),
    'day of week tomorrow'  => test_zci( build_answer( $dt_tomorrow->day_name,  $dt_tomorrow->strftime("%d %b %Y") ) ),
    'day of week yesterday' => test_zci( build_answer( $dt_yesterday->day_name, $dt_yesterday->strftime("%d %b %Y") ) ),

    'day of week' => undef,
    'day of week' => undef,
);

done_testing;
