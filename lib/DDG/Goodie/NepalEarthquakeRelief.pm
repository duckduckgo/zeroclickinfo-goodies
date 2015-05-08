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
    };
    
};

1;
