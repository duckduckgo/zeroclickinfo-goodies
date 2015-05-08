#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "nepal_earthquake_relief";
zci is_cached   => 1;

# All responses for this goodie are the same
my @test_zci = (
  "Help Nepal Earthquake Relief",
    structured_answer => {
        id => 'nepal_earthquake_relief',
        name => 'Nepal Earthquake Relief',
        data => {
            title => "Ways to help Nepal earthquake relief",
            description => "You can donate and that relief charities will be mounting a response to assist 
            with the immediate aftereffects of this disaster, and share this information with others by posting 
            on Facebook, Twitter, Instagram and all your social media platforms using the #SupportNepal hashtag 
            to encourage others to donate and help as well."
        },
        meta => {
            sourceName => "TIME 6 Ways You Can Give to Nepal Earthquake Relief",
            sourceUrl => "http://time.com/3836242/nepal-earthquake-donations-disaster-relief/"
        },
        templates => {
            group => 'info',
            options => {
                moreAt => 1
            }
        }
    }
);  

ddg_goodie_test(
    [qw( DDG::Goodie::NepalEarthquakeRelief )],
    # - primary_example_queries
    'Nepal earthquake relief' => test_zci(@test_zci),
    'Nepal relief' => test_zci(@test_zci),
    'Support Nepal' => test_zci(@test_zci),
);

done_testing;
