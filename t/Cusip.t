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
        'cusip 037833100' => test_zci("037833100 has a valid CUSIP check digit."),
        'cusip 844741108' => test_zci("844741108 has a valid CUSIP check digit."),

        # starting white space should be stripped
        'cusip      037833100' => test_zci("037833100 has a valid CUSIP check digit."),

        # ending white space should be stripped
        'cusip 037833100     ' => test_zci("037833100 has a valid CUSIP check digit."),

        # starting and ending white space should be stripped
        'cusip     037833100     ' => test_zci("037833100 has a valid CUSIP check digit."),

        # same AAPL queries with an incorrect check digit
        'cusip 03783310A' => test_zci("03783310A does NOT have a valid CUSIP check digit."),
        'cusip      03783310A' => test_zci("03783310A does NOT have a valid CUSIP check digit."),
        'cusip 03783310A     ' => test_zci("03783310A does NOT have a valid CUSIP check digit."),
        'cusip     03783310A     ' => test_zci("03783310A does NOT have a valid CUSIP check digit."),
        
        # check CUSIP IDs with capital letters (these are for GOOG and Blackberry)
        'cusip 38259P706' => test_zci("38259P706 has a valid CUSIP check digit."),
        'cusip 38259P508' => test_zci("38259P508 has a valid CUSIP check digit."),
        'cusip 09228F103' => test_zci("09228F103 has a valid CUSIP check digit."),

        # check the same CUSIP IDs with lower case letters
        'cusip 38259p706' => test_zci("38259P706 has a valid CUSIP check digit."),
        'cusip 38259p508' => test_zci("38259P508 has a valid CUSIP check digit."),
        'cusip 09228f103' => test_zci("09228F103 has a valid CUSIP check digit."),        
               
        # check CUSIP IDs with '*', '#', and '@'
        # these CUSIP ID check digits were calculated by hand
        # if possible, these tests should be replaced with verified CUSIP IDs
        'cusip 037833*00' => test_zci("037833*00 does NOT have a valid CUSIP check digit."),
        'cusip 037833*02' => test_zci("037833*02 has a valid CUSIP check digit."),
        'cusip 0378331#0' => test_zci("0378331#0 does NOT have a valid CUSIP check digit."),
        'cusip 0378331#7' => test_zci("0378331#7 has a valid CUSIP check digit."),
        'cusip 037833@00' => test_zci("037833\@00 does NOT have a valid CUSIP check digit."),
        'cusip 037833@01' => test_zci("037833\@01 has a valid CUSIP check digit."), 
        
        # CUSIP IDs ending in '*', '#', and '@' should not break the IA 
        # even though they are always invalid IDs
        'cusip 03783310*' => test_zci("03783310* does NOT have a valid CUSIP check digit."),
        'cusip 03783310#' => test_zci("03783310# does NOT have a valid CUSIP check digit."),
        'cusip 03783310@' => test_zci("03783310\@ does NOT have a valid CUSIP check digit."),

        # Odd CUSIP IDs should not break the IA
        'cusip ********8' => test_zci("********8 has a valid CUSIP check digit."),
        'cusip ########9' => test_zci("########9 does NOT have a valid CUSIP check digit."),
        'cusip @#*@#*@#*' => test_zci("\@#*\@#*\@#* does NOT have a valid CUSIP check digit."),
 );

done_testing;

