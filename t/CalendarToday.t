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
    # today
    "calendar today" => test_zci("calendar today",  make_structured_answer(6, 2015) ),
    # today
    "cal" => test_zci("calendar today",  make_structured_answer(6, 2015) ),
    # month query (next january)
    "cal january" => test_zci("calendar today", make_structured_answer(1, 2016)),
    # year query (2004)
    "cal 2004" => test_zci("calendar today", make_structured_answer(6, 2004)),
    # year month query (feb 2003)
    "cal february 2003" => test_zci("calendar today", make_structured_answer(2, 2003)),
);

sub make_structured_answer {
    my ($month, $year ) = @_;

    return structured_answer => {
        id => 'calendar_today',
        data => {
            month => $month,
            year => $year
        },
        templates => 1
    };
};

restore_time();

done_testing;
