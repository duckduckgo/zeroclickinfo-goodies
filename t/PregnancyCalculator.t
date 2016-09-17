#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Test::Deep

zci answer_type => "pregnancy_calculator";
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::PregnancyCalculator )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'lmp 14 Feb 2016' => test_zci(qr/Pregnancy currently at \d{1,2} \+ \d{1} days. Due date \(40 weeks\) will be 20 Nov 2016/,
        structured_answer => {
            id => 'pregnancy_calculator',
            name => 'Health',
            meta => {
                sourceUrl => 'https://en.wikipedia.org/wiki/Estimated_date_of_confinement',
                sourceName => 'Wikipedia'
            },
            input => "14 Feb 2016",
            operation => "Last menstrual period",

            templates => {
               group => "text",
            },
            data => {
              title => re(qr/Currently \d{1,3} weeks \+ \d{1} days\./),
              subtitle => "Full term (40 weeks) : 20 Nov 2016",
              description => "Based on last menstrual period of 14 Feb 2016 and cycle length of 28 days."
            },
              
        }),
     'last period 15-1-2030' => test_zci('Due date (40 weeks) will be 22 Oct 2030', #test on a future date. Will need updating in2030
        structured_answer => {
            id=> 'pregnancy_calculator',
            name =>'Health',
            meta => {
                sourceUrl => 'https://en.wikipedia.org/wiki/Estimated_date_of_confinement',
                sourceName => 'Wikipedia'
            },
            input =>"15 Jan 2030",
            operation => "Last menstrual period",
            
            templates => {
                group => "text",
            },
            data => {
                title => "Full term (40 weeks) : 22 Oct 2030",
                subtitle => "",
                description => "Based on last menstrual period of 15 Jan 2030 and cycle length of 28 days."
                },
        }),

# Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'lmp 29 Feb 2015' => undef, #Not a date
    'lmp last Thursday' => undef, #Not a date that we can deal with
    'lmp' => undef, #Ned some arguments
);

done_testing;
