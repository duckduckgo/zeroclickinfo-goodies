#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => 'calendar';
zci is_cached   => 0;

ddg_goodie_test(
    [qw(
        DDG::Goodie::CalendarToday
    )],
    'calendar' => test_zci(
        qr/\nS M T W T F S[ ]+[A-Za-z]+ [0-9]{4}\n.+/, 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar november' => test_zci(
        qr/\nS M T W T F S      November [0-9]{4}\n.+/, 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar november 12th' => test_zci(
        qr/\nS M T W T F S      November [0-9]{4}\n.+/, 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar last november' => test_zci(
        qr/\nS M T W T F S      November [0-9]{4}\n.+/, 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar next november' => test_zci(
        qr/\nS M T W T F S      November [0-9]{4}\n.+/, 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar november 2009' => test_zci("
S M T W T F S      November 2009
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
 29  30 
", 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar nov 2009' => test_zci("
S M T W T F S      November 2009
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
 29  30 
", 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar 29 nov 2015' => test_zci("
S M T W T F S      November 2015
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
|29| 30 
", 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar 29.11.2015' => test_zci("
S M T W T F S      November 2015
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
|29| 30 
", 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'cal 1980-11-29' => test_zci("
S M T W T F S      November 1980
                          1 
  2   3   4   5   6   7   8 
  9  10  11  12  13  14  15 
 16  17  18  19  20  21  22 
 23  24  25  26  27  28 |29|
 30 
", 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar for november 2009' => test_zci("
S M T W T F S      November 2009
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
 29  30 
", 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),    
    'next november on a calendar' => test_zci(
        qr/\nS M T W T F S      November [0-9]{4}\n.+/, 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar for november'     => test_zci(
        qr/\nS M T W T F S      November [0-9]{4}\n.+/, 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar of november 2009' => test_zci("
S M T W T F S      November 2009
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
 29  30 
", 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    '22/8/2003 to the hijri calendar' => undef,
    "today's calendar" => test_zci(
        qr/\nS M T W T F S      [A-Z][a-z]+ [0-9]{4}\n.+/, 
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    "november's calendar" => test_zci(
        qr/\nS M T W T F S      November [0-9]{4}\n.+/,
        structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
);

# Special focus on relative dates, examining the "today" circle
my $test_location_tz = qr/\(EDT, UTC-4\)/;
set_fixed_time("2014-06-11T09:45:56");
ddg_goodie_test(
    [qw(
        DDG::Goodie::CalendarToday
    )],
    "calendar yesterday" => test_zci(
        qr/June 2014.*\|10\|/s,
		structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    "calendar today"     => test_zci(
        qr/June 2014.*\|11\|/s,
		structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    "calendar tomorrow"  => test_zci(
        qr/June 2014.*\|12\|/s,
		structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    "calendar 20 days ago" => test_zci(
        qr/May 2014.*\|22\|/s,
		structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    "calendar in 20 days" => test_zci(
        qr/July 2014.*\| 1\|/s,
		structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    "calendar last week" => test_zci(
        qr/June 2014.*\| 4\|/s,
		structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    "calendar next week" => 
        test_zci(qr/June 2014.*\|18\|/s,
		structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    "calendar last year" => 
        test_zci(qr/June 2013.*\|11\|/s,
		structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    "calendar next year" => 
        test_zci(qr/June 2015.*\|11\|/s,
		structured_answer => {
            id => 'calendar_today',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
);
restore_time();

done_testing;

