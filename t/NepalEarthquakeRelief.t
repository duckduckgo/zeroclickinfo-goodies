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
  html => "
            <h3>Ways to help Nepal earthquake relief:</h3>
            
            <h6>1. Donate</h6>
            <p>You can donate and that relief charities will be mounting a response to assist with the immediate aftereffects of this disaster.</p>
            <p><a href='http://www.charitynavigator.org/index.cfm?bay=content.view&cpid=1888#.VULgJSGqpBd'>Donate to charities here.</a></p>
            
            <h6>2. #SupportNepal</h6>
            <p>Share this information with others by posting on Facebook, Twitter, Instagram and all your social media platforms using the <a href='https://twitter.com/search?q=%23supportnepal&src=typd'>#SupportNepal</a> hashtag to encourage others to donate and help as well. </p>
            
            <h4>Read More:</h4>
            <p><a href='http://time.com/3836242/nepal-earthquake-donations-disaster-relief/'>TIME 6 Ways You Can Give to Nepal Earthquake Relief</a></p>
            <p><a href='http://mariashriver.com/blog/2015/04/8-ways-you-can-help-nepal-earthquake-victims/'>8 Ways You Can Help Nepal Earthquake Victims BY MARIASHRIVER.COM</a></p>
            
            ",
);  

ddg_goodie_test(
    [qw( DDG::Goodie::NepalEarthquakeRelief )],
    # - primary_example_queries
    'Nepal earthquake relief' => test_zci(@test_zci),
    'Nepal relief' => test_zci(@test_zci),
    'Support Nepal' => test_zci(@test_zci),
);

done_testing;
