package DDG::Goodie::PackageTracking;
# ABSTRACT:  Track a shipment from any courier

use DDG::Goodie;
use DDG::GoodiePackageTracking;
use strict;

zci answer_type => 'package_tracking';
zci is_cached   => 1;

triggers any => 'triggerWord', 'trigger phrase';

primary_example_queries "123456789012";
secondary_example_queries "1234567890123456789";
description	"Track a shipment from any courier";
name "packagetracking";
category "ids";
topics "special_interest";
attribution github => ["https://github.com/Mailkov", "Melchiorre Alastra"];

#load all couriers


# Handle statement
handle remainder => sub {

    my $remainder = $_;
    
    my @packagecouriers;
    #validation package for couriers
    
    
    
    

    return "plain text response",
        structured_answer => {
            id => 'package_tracking',
            name => 'Answer',

            data => {
              title => "My Instant Answer Title",
              subtitle => "My Subtitle",
              list => 
            },

            templates => {
                group => "list",
            }
        };
};

1;
