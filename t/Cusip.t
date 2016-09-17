#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "cusip";


sub build_test {

    my $title = shift;
    return test_zci(
        $title,
        structured_answer => {
            data => {
                title => $title,
            },
            templates => {
                group => 'text',
            }
        }
    );
}

ddg_goodie_test(
    ['DDG::Goodie::Cusip'],

    #####
    # triggers that SHOULD load the IA

    # typical well-formed queries for AAPL and Southwest
    'cusip 037833100'       => build_test('037833100 is a properly formatted CUSIP number'),
    'cusip check 037833100' => build_test('037833100 is a properly formatted CUSIP number'),
    'cusip 844741108'       => build_test('844741108 is a properly formatted CUSIP number'),
    '037833100 cusip'       => build_test('037833100 is a properly formatted CUSIP number'),
    '037833100 cusip check' => build_test('037833100 is a properly formatted CUSIP number'),

    # starting white space should be stripped
    'cusip      037833100' => build_test('037833100 is a properly formatted CUSIP number'),

    # ending white space should be stripped
    'cusip 037833100     ' => build_test('037833100 is a properly formatted CUSIP number'),

    # starting and ending white space should be stripped
    'cusip     037833100     ' => build_test('037833100 is a properly formatted CUSIP number'),

    # same AAPL queries with an incorrect check digit
    'cusip 03783310A'          => build_test('03783310A is not a properly formatted CUSIP number'),
    'cusip      03783310A'     => build_test('03783310A is not a properly formatted CUSIP number'),
    'cusip 03783310A     '     => build_test('03783310A is not a properly formatted CUSIP number'),
    'cusip     03783310A     ' => build_test('03783310A is not a properly formatted CUSIP number'),

    # check CUSIP IDs with capital letters (these are for GOOG and Blackberry)
    'cusip 38259P706' => build_test('38259P706 is a properly formatted CUSIP number'),
    'cusip 38259P508' => build_test('38259P508 is a properly formatted CUSIP number'),
    'cusip 09228F103' => build_test('09228F103 is a properly formatted CUSIP number'),

    # check the same CUSIP IDs with lower case letters
    'cusip 38259p706' => build_test('38259P706 is a properly formatted CUSIP number'),
    'cusip 38259p508' => build_test('38259P508 is a properly formatted CUSIP number'),
    'cusip 09228f103' => build_test('09228F103 is a properly formatted CUSIP number'),

    # check CUSIP IDs with '*', '#', and '@'
    # these CUSIP ID check digits were calculated by hand
    # if possible, these tests should be replaced with verified CUSIP IDs
    'cusip 037833*00' => build_test('037833*00 is not a properly formatted CUSIP number'),
    'cusip 037833*02' => build_test('037833*02 is a properly formatted CUSIP number'),
    'cusip 0378331#0' => build_test('0378331#0 is not a properly formatted CUSIP number'),
    'cusip 0378331#7' => build_test('0378331#7 is a properly formatted CUSIP number'),
    'cusip 037833@00' => build_test('037833@00 is not a properly formatted CUSIP number'),
    'cusip 037833@01' => build_test('037833@01 is a properly formatted CUSIP number'),

    # CUSIP IDs ending in '*', '#', and '@' should not break the IA
    # even though they are always invalid IDs
    'cusip 03783310*' => build_test('03783310* is not a properly formatted CUSIP number'),
    'cusip 03783310#' => build_test('03783310# is not a properly formatted CUSIP number'),
    'cusip 03783310@' => build_test('03783310@ is not a properly formatted CUSIP number'),

    # Odd CUSIP IDs should not break the IA
    'cusip ********8' => build_test('********8 is not a properly formatted CUSIP number'),
    'cusip ########9' => build_test('########9 is not a properly formatted CUSIP number'),
    'cusip @#*@#*@#*' => build_test('@#*@#*@#* is not a properly formatted CUSIP number'),

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
    'cusip 037833100 12345'     => undef,
    'cusip 12345 037833100'     => undef,
    'cusip 01234 56789'         => undef,
);

done_testing;