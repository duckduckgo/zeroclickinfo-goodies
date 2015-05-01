package DDG::Goodie::NepalEarthquakeRelief;
# ABSTRACT: Provide ways to help Nepal earthquake relief

use DDG::Goodie;

zci answer_type => "nepal_earthquake_relief";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "NepalEarthquakeRelief";
description "Provide ways to help Nepal earthquake relief";
primary_example_queries "Nepal earthquake", "Nepal relief", "Support Nepal";
category "special";
topics "trivia";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/NepalEarthquakeRelief.pm";
attribution github => ["https://github.com/wongalvis", "wongalvis"];

# Triggers
triggers any => "nepal earthquake relief", "nepal earthquake help", "nepal earthquake support", "nepal relief", "support nepal", "help nepal";

# Handle statement
handle remainder => sub {
    
    return "Help Nepal Earthquake Relief",
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
            
            ";
    
};

1;
