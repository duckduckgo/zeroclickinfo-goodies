package DDG::Goodie::PackageTracking;
# ABSTRACT:  Track a shipment from any courier

use DDG::Goodie;
use strict;
use YAML::XS 'LoadFile';

zci answer_type => 'package_tracking';
zci is_cached   => 1;

triggers start => '123456789012', '1234567890123456789';

primary_example_queries "123456789012";
secondary_example_queries "1234567890123456789";
description	"Track a shipment from any courier";
name "packagetracking";
category "ids";
topics "special_interest";
attribution github => ["https://github.com/Mailkov", "Melchiorre Alastra"];

#load all couriers
my @couriers = @{LoadFile(share('couriers.yml'))};

my @trackclass;
#create and load class
foreach (@couriers) { 
    my $nameclass = "DDG::GoodiePackageTracking::$_"; 
    with $nameclass;
    push @trackclass, $nameclass;
}

# Handle statement
handle query => sub {

    my $query = $_;
    
    #verify package number for all couriers
    my @response;
    foreach (@trackclass) { 
        my $nameclass = $_;
        push @response, $nameclass->isPackageTracking($query);
    }
    
    return "$query",
        structured_answer => {
            id => 'package_tracking',
            name => 'Answer',
            data => {
              title => "My Instant Answer Title",
              subtitle => "My Subtitle",
              image => "",
              list => \@response,
            },
            templates => {
                group => "list",
            }
        };
};

1;

sub opera {
    my $name = "DDG::GoodiePackageTracking::$_[0]";
    return $name->isPackageTracking("123456789012");
};
