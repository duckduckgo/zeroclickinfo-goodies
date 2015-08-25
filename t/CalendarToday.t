#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => 'calendar';
zci is_cached   => 0;

my $test_location_tz = qr/\(EDT, UTC-4\)/;
set_fixed_time("2015-06-11T09:45:56");
ddg_goodie_test(
    [qw(
        DDG::Goodie::CalendarToday
    )],
    "calendar" => test_zci( "calendar today",  make_structured_answer(6, 11, 2015) ),
);

sub make_structured_answer {
    my ($month, $day, $year ) = @_;

    return structured_answer => {
        id => 'calendar_today',
        name => 'Answer',
        data => {
            day => $day,
            month => $month,
            year => $year
        },
        templates => {
           group => 'base',
           detail => 0,
            options => {
                content => 'DDH.calendar_today.content',
            }
        }
    };
};

restore_time();

done_testing;
