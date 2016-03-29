#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );
use DDG::Test::Location;

zci answer_type => 'calendar';
zci is_cached   => 0;

sub location_test {
    my ($location_code, $query, @res_params) = @_;
    my $location = test_location($location_code);
    return DDG::Request->new(
        query_raw => $query,
        location => $location
    ) => test_zci(@res_params);
}

ddg_goodie_test(
    [qw(
        DDG::Goodie::CalendarToday
    )],
    'calendar' => test_zci(
        re(qr/\nS M T W T F S[ ]+[A-Za-z]+ [0-9]{4}\n.+/), 
        structured_answer => {
            data => ignore(),
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
        re(qr/\nS M T W T F S      November [0-9]{4}\n.+/), 
        structured_answer => {
            data => ignore(),
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
        re(qr/\nS M T W T F S      November [0-9]{4}\n.+/), 
        structured_answer => {
            data => ignore(),
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
        re(qr/\nS M T W T F S      November [0-9]{4}\n.+/), 
        structured_answer => {
            data => ignore(),
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
        re(qr/\nS M T W T F S      November [0-9]{4}\n.+/), 
        structured_answer => {
            data => ignore(),
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
            data => {
                month_year => "November 2009",                                                                                                               
                next_month => "December 2009",                                                                                                               
                previous_month => "October 2009",
                weeks => [ 
                    [ 
                        {day => 1, today => ""},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                        {day => 7, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => ""},                                                                                                                                      
                        {day => 11, today => ""},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                        {day => 14, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                        {day => 21, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 22, today => ""},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},                                                                                                                                      
                        {day => 27, today => ""},                                                                                                                                      
                        {day => 28, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 29, today => ""},                                                                                                                                      
                        {day => 30, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                ]
            },    
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    'calendar 10 nov 2009' => test_zci("
S M T W T F S      November 2009
  1   2   3   4   5   6   7 
  8   9 |10| 11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
 29  30 
", 
        structured_answer => {
            data => {
                month_year => "November 2009",                                                                                                               
                next_month => "December 2009",                                                                                                               
                previous_month => "October 2009",
                weeks => [ 
                    [ 
                        {day => 1, today => ""},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                        {day => 7, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => "1"},                                                                                                                                      
                        {day => 11, today => ""},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                        {day => 14, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                        {day => 21, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 22, today => ""},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},                                                                                                                                      
                        {day => 27, today => ""},                                                                                                                                      
                        {day => 28, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 29, today => ""},                                                                                                                                      
                        {day => 30, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                ]
            },    
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
            data => ignore(),
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
            data => ignore(),
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.calendar_today.content'
                }
            }
        }
    ),
    location_test('de', 'calendar 29.11.2015', "
S M T W T F S      November 2015
  1   2   3   4   5   6   7 
  8   9  10  11  12  13  14 
 15  16  17  18  19  20  21 
 22  23  24  25  26  27  28 
|29| 30 
", 
        structured_answer => {
            data => ignore(),
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
            data => ignore(),
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
            data => ignore(),
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
        re(qr/\nS M T W T F S      November [0-9]{4}\n.+/), 
        structured_answer => {
            data => ignore(),
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
        re(qr/\nS M T W T F S      November [0-9]{4}\n.+/), 
        structured_answer => {
            data => ignore(),
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
            data => ignore(),
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
        re(qr/\nS M T W T F S      [A-Z][a-z]+ [0-9]{4}\n.+/), 
        structured_answer => {
            data => ignore(),
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
        re(qr/\nS M T W T F S      November [0-9]{4}\n.+/),
        structured_answer => {
            data => ignore(),
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
my $test_location_tz = re(qr/\(EDT, UTC-4\)/);
set_fixed_time("2014-06-11T09:45:56");
ddg_goodie_test(
    [qw(
        DDG::Goodie::CalendarToday
    )],
    "calendar yesterday" => test_zci(
        re(qr/June 2014.*\|10\|/s),
		structured_answer => {
            data => {
                month_year => "June 2014",                                                                                                               
                next_month => "July 2014",                                                                                                               
                previous_month => "May 2014",
                weeks => [ 
                    [ 
                        {day => 1, today => ""},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                        {day => 7, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => "1"},                                                                                                                                      
                        {day => 11, today => ""},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                        {day => 14, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                        {day => 21, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 22, today => ""},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},                                                                                                                                      
                        {day => 27, today => ""},                                                                                                                                      
                        {day => 28, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 29, today => ""},                                                                                                                                      
                        {day => 30, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                ]
            }, 
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
        re(qr/June 2014.*\|11\|/s),
		structured_answer => {
            data => {
                month_year => "June 2014",                                                                                                               
                next_month => "July 2014",                                                                                                               
                previous_month => "May 2014",
                weeks => [ 
                    [ 
                        {day => 1, today => ""},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                        {day => 7, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => ""},                                                                                                                                      
                        {day => 11, today => "1"},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                        {day => 14, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                        {day => 21, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 22, today => ""},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},                                                                                                                                      
                        {day => 27, today => ""},                                                                                                                                      
                        {day => 28, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 29, today => ""},                                                                                                                                      
                        {day => 30, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                ]
            }, 
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
        re(qr/June 2014.*\|12\|/s),
		structured_answer => {
            data => {
                month_year => "June 2014",                                                                                                               
                next_month => "July 2014",                                                                                                               
                previous_month => "May 2014",
                weeks => [ 
                    [ 
                        {day => 1, today => ""},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                        {day => 7, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => ""},                                                                                                                                      
                        {day => 11, today => ""},                                                                                                                                      
                        {day => 12, today => "1"},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                        {day => 14, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                        {day => 21, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 22, today => ""},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},                                                                                                                                      
                        {day => 27, today => ""},                                                                                                                                      
                        {day => 28, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 29, today => ""},                                                                                                                                      
                        {day => 30, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                ]
            }, 
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
        re(qr/May 2014.*\|22\|/s),
		structured_answer => {
            data => {
                month_year => "May 2014",                                                                                                               
                next_month => "June 2014",                                                                                                               
                previous_month => "April 2014",
                weeks => [ 
                    [ 
                        {day => " ", today => ""},                                                                                                                                      
                        {day => " ", today => ""},                                                                                                                                      
                        {day => " ", today => ""},                                                                                                                                      
                        {day => " ", today => ""},                                                                                                                                      
                        {day => 1, today => ""},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                        {day => 7, today => ""},                                                                                                                                      
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 11, today => ""},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                        {day => 14, today => ""},                                                                                                                                      
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                        {day => 21, today => ""},                                                                                                                                      
                        {day => 22, today => "1"},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},
                        {day => 27, today => ""},
                        {day => 28, today => ""},
                        {day => 29, today => ""},
                        {day => 30, today => ""},
                        {day => 31, today => ""},
                    ],
                ]
            }, 
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
        re(qr/July 2014.*\| 1\|/s),
		structured_answer => {
            data => {
                month_year => "July 2014",                                                                                                               
                next_month => "August 2014",                                                                                                               
                previous_month => "June 2014",
                weeks => [ 
                    [ 
                        {day => " ", today => ""},
                        {day => " ", today => ""},
                        {day => 1, today => "1"},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                    [ 
                        {day => 6, today => ""},
                        {day => 7, today => ""},                                                                                                                                      
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => ""},                                                                                                                                      
                        {day => 11, today => ""},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                    [
                        {day => 13, today => ""},                    
                        {day => 14, today => ""},                                                                                                                                      
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                    [ 
                        {day => 20, today => ""},                    
                        {day => 21, today => ""},                                                                                                                                      
                        {day => 22, today => ""},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                    [
                        {day => 27, today => ""},                    
                        {day => 28, today => ""},                                                                                                                                      
                        {day => 29, today => ""},
                        {day => 30, today => ""},
                        {day => 31, today => ""},
                    ],
                ]
            }, 
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
        re(qr/June 2014.*\| 4\|/s),
		structured_answer => {
            data => {
                month_year => "June 2014",                                                                                                               
                next_month => "July 2014",                                                                                                               
                previous_month => "May 2014",
                weeks => [ 
                    [ 
                        {day => 1, today => ""},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => "1"},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                        {day => 7, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => ""},                                                                                                                                      
                        {day => 11, today => ""},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                        {day => 14, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                        {day => 21, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 22, today => ""},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},                                                                                                                                      
                        {day => 27, today => ""},                                                                                                                                      
                        {day => 28, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 29, today => ""},                                                                                                                                      
                        {day => 30, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                ]
            }, 
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
        test_zci(re(qr/June 2014.*\|18\|/s),
		structured_answer => {
            data => {
                month_year => "June 2014",                                                                                                               
                next_month => "July 2014",                                                                                                               
                previous_month => "May 2014",
                weeks => [ 
                    [ 
                        {day => 1, today => ""},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                        {day => 7, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => ""},                                                                                                                                      
                        {day => 11, today => ""},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                        {day => 14, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => "1"},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                        {day => 21, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 22, today => ""},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},                                                                                                                                      
                        {day => 27, today => ""},                                                                                                                                      
                        {day => 28, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 29, today => ""},                                                                                                                                      
                        {day => 30, today => ""},                                                                                                                                                                                                                                                                            
                    ],
                ]
            }, 
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
        test_zci(re(qr/June 2013.*\|11\|/s),
		structured_answer => {
            data => {
                month_year => "June 2013",                                                                                                               
                next_month => "July 2013",                                                                                                               
                previous_month => "May 2013",
                weeks => [ 
                    [ 
                        {day => " ", today => ""},                                                                                                                                      
                        {day => " ", today => ""},                                                                                                                                      
                        {day => " ", today => ""},                                                                                                                                      
                        {day => " ", today => ""},                                                                                                                                      
                        {day => " ", today => ""},                                                                                                                                      
                        {day => " ", today => ""},                                                                                                                                      
                        {day => 1, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                        {day => 7, today => ""},                                                                                                                                      
                        {day => 8, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => ""},                                                                                                                                      
                        {day => 11, today => "1"},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                        {day => 14, today => ""},                                                                                                                                      
                        {day => 15, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                        {day => 21, today => ""},                                                                                                                                      
                        {day => 22, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},
                        {day => 27, today => ""},                                                                                                                                      
                        {day => 28, today => ""}, 
                        {day => 29, today => ""},                        
                    ],
                    [ 
                        {day => 30, today => ""},                                                                                                                                                              
                    ],
                ]
            }, 
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
        test_zci(re(qr/June 2015.*\|11\|/s),
		structured_answer => {
            data => {
                month_year => "June 2015",                                                                                                               
                next_month => "July 2015",                                                                                                               
                previous_month => "May 2015",
                weeks => [ 
                    [ 
                        {day => " ", today => ""},                                                                                                                                      
                        {day => 1, today => ""},                                                                                                                                      
                        {day => 2, today => ""},                                                                                                                                      
                        {day => 3, today => ""},                                                                                                                                      
                        {day => 4, today => ""},                                                                                                                                      
                        {day => 5, today => ""},                                                                                                                                      
                        {day => 6, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 7, today => ""},                                                                                                                                      
                        {day => 8, today => ""},                                                                                                                                      
                        {day => 9, today => ""},                                                                                                                                      
                        {day => 10, today => ""},                                                                                                                                      
                        {day => 11, today => "1"},                                                                                                                                      
                        {day => 12, today => ""},                                                                                                                                      
                        {day => 13, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 14, today => ""},                                                                                                                                      
                        {day => 15, today => ""},                                                                                                                                      
                        {day => 16, today => ""},                                                                                                                                      
                        {day => 17, today => ""},                                                                                                                                      
                        {day => 18, today => ""},                                                                                                                                      
                        {day => 19, today => ""},                                                                                                                                      
                        {day => 20, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 21, today => ""},                                                                                                                                      
                        {day => 22, today => ""},                                                                                                                                      
                        {day => 23, today => ""},                                                                                                                                      
                        {day => 24, today => ""},                                                                                                                                      
                        {day => 25, today => ""},                                                                                                                                      
                        {day => 26, today => ""},                                                                                                                                      
                        {day => 27, today => ""},                                                                                                                                      
                    ],
                    [ 
                        {day => 28, today => ""},                                                                                                                                      
                        {day => 29, today => ""},
                        {day => 30, today => ""},
                    ],
                ]
            }, 
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
