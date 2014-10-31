#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "national_independence_day";
zci is_cached   => 1;

my $heading = 'National independence day';

ddg_goodie_test(
    [qw( DDG::Goodie::NationalIndependenceDay::YouriAckx )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    
    # Full postitive tests
    'independence day belgium' => test_zci("Independence day of Belgium\nJuly 21st, 1831",
        html =>  qr"<div class=\"text--primary\">Independence day of Belgium</div><div class=\"text--secondary\">July 21st, 1831</div>"s,
        heading => $heading
    ),
    'national independence day belgium' => test_zci("Independence day of Belgium\nJuly 21st, 1831",
        html =>  qr"<div class=\"text--primary\">Independence day of Belgium</div><div class=\"text--secondary\">July 21st, 1831</div>"s,
        heading => $heading
    ),

    # Casual other tests
    'independence day cyprus' => test_zci("Independence day of Cyprus\nOctober 1st, 1960",
        html =>  qr"<div class=\"text--primary\">.*</div><div class=\"text--secondary\">.*</div>"s,
        heading => $heading
    ),
        
    
    # Country with several words
    'independence day costa rica' => test_zci("Independence day of Costa Rica\nSeptember 15th, 1821",
        html =>  qr"<div class=\"text--primary\">.*</div><div class=\"text--secondary\">.*</div>"s,
        heading => $heading
    ),

    # Output a single date when there are two entries
    'independence day lithuania' => test_zci("Independence day of Lithuania\nFebruary 16th, 1918",
        html =>  qr"<div class=\"text--primary\">.*</div><div class=\"text--secondary\">.*</div>"s,
        heading => $heading
    ),

    # Accented letters
    #'independence day são tomé and príncipe' => test_zci("Independence day of são tomé and príncipe\nJuly 12th, 1975",
    #    html =>  qr"<div class=\"text--primary\">.*</div><div class=\"text--secondary\">.*</div>"s,
    #    heading => $heading
    #),
    
    # Missing country (do not summon our goodie)
    'independence day' => undef,
    'national independence day' => undef,

    # Country does not exist
    'independence day foobar' => undef,
    'national independence day foobar' => undef,

    # Independence day != National day. Gotcha.
    'independence day france' => undef,

    # Not our goodie at all
    'bad example belgium' => undef,
    'independence belgium' => undef,
    'national independence belgium' => undef,
);

done_testing;
