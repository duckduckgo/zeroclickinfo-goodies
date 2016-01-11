#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "cusip";

ddg_goodie_test(
    ['DDG::Goodie::Cusip'],

    #####
    # triggers that SHOULD NOT load the IA

    # a query with no text should not trigger the IA
    'cusip' => undef,

    # queries with not enough chars should not trigger the IA
    'cusip 0' => undef,
    'cusip 01234#' => undef,

    # queries with too many chars should not trigger the IA
    'cusip 0123456789' => undef,

    # white spaces should not be counted as chars
    'cusip      6789' => undef,
    'cusip 1234     ' => undef,
    'cusip 1234 6789' => undef,

    # queries with nonalphanumeric chars that are not '*', '#', or '@'
    # should not trigger the IA
    'cusip _12345678' => undef,
    'cusip 01234567+' => undef,

    # multiple IDs are not currently checked
    'cusip 037833100 037833100' => undef,
    'cusip 037833100 12345' => undef,
    'cusip 12345 037833100' => undef,
    'cusip 01234 56789' => undef,

    #####
    # triggers that SHOULD load the IA

    # typical well-formed queries for AAPL and Southwest
    'cusip 037833100' => test_zci(
        "037833100 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => {
                title => "037833100 is a properly formatted CUSIP number.",
            },
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip check 037833100' => test_zci("037833100 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 844741108' => test_zci("844741108 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    '037833100 cusip' => test_zci("037833100 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    '037833100 cusip check' => test_zci("037833100 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),

    # starting white space should be stripped
    'cusip      037833100' => test_zci("037833100 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),

    # ending white space should be stripped
    'cusip 037833100     ' => test_zci("037833100 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),

    # starting and ending white space should be stripped
    'cusip     037833100     ' => test_zci("037833100 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),

    # same AAPL queries with an incorrect check digit
    'cusip 03783310A' => test_zci("03783310A is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip      03783310A' => test_zci("03783310A is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 03783310A     ' => test_zci("03783310A is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip     03783310A     ' => test_zci("03783310A is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),

    # check CUSIP IDs with capital letters (these are for GOOG and Blackberry)
    'cusip 38259P706' => test_zci("38259P706 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 38259P508' => test_zci("38259P508 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 09228F103' => test_zci("09228F103 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),

    # check the same CUSIP IDs with lower case letters
    'cusip 38259p706' => test_zci("38259P706 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 38259p508' => test_zci("38259P508 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 09228f103' => test_zci("09228F103 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),

    # check CUSIP IDs with '*', '#', and '@'
    # these CUSIP ID check digits were calculated by hand
    # if possible, these tests should be replaced with verified CUSIP IDs
    'cusip 037833*00' => test_zci("037833*00 is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 037833*02' => test_zci("037833*02 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 0378331#0' => test_zci("0378331#0 is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 0378331#7' => test_zci("0378331#7 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 037833@00' => test_zci("037833\@00 is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 037833@01' => test_zci("037833\@01 is a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),

    # CUSIP IDs ending in '*', '#', and '@' should not break the IA
    # even though they are always invalid IDs
    'cusip 03783310*' => test_zci("03783310* is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 03783310#' => test_zci("03783310# is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip 03783310@' => test_zci("03783310\@ is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),

    # Odd CUSIP IDs should not break the IA
    'cusip ********8' => test_zci("********8 is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip ########9' => test_zci("########9 is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
    'cusip @#*@#*@#*' => test_zci("\@#*\@#*\@#* is not a properly formatted CUSIP number.",
        structured_answer => {
            id => 'cusip',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'text',
            }
        }
    ),
 );

done_testing;

