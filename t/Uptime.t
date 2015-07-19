#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "uptime";
zci is_cached   => 1;

sub build_structure {
    my ($title, $subtitle, $percentage, $data, $keys) = @_;
    
    return {
        id => "uptime",
        name => "Answer",
        templates => {
            group => "list",
            options => {
                content => "record"
            }
        },
        data => {
            title => $title,
            subtitle => $subtitle,
            record_data => $data,
            record_keys => $keys
        }
    }
}

sub build_list_structure {
    my ($percentage, $data) = @_;
    return build_structure(
        "Implied downtimes for $percentage uptime",
        undef,
        $percentage,
        $data,
        ["daily", "monthly", "yearly"]
    );
}

sub build_text_structure {
    my ($percentage) = @_;
    return build_structure(
        "No downtime or less than a second during a year",
        "Implied downtimes for $percentage uptime",
        $percentage,
        undef,
        undef
    );
}

ddg_goodie_test(
    [qw( DDG::Goodie::Uptime )],
    
    'uptime 99%' => test_zci("Implied downtimes for 99% uptime\n".
                            "Daily: 14 minutes and 24 seconds\n".
                            "Monthly: 7 hours and 18 minutes\n".
                            "Annually: 3 days and 16 hours",
                            structured_answer => build_list_structure("99%",{
                                "daily" => "14 minutes and 24 seconds",
                                "monthly" => "7 hours and 18 minutes",
                                "yearly" => "3 days and 16 hours"
                            })),

    # Alternate trigger
    'uptime of 99%' => test_zci("Implied downtimes for 99% uptime\n".
                            "Daily: 14 minutes and 24 seconds\n".
                            "Monthly: 7 hours and 18 minutes\n".
                            "Annually: 3 days and 16 hours",
                            structured_answer => build_list_structure("99%",{
                                "daily" => "14 minutes and 24 seconds",
                                "monthly" => "7 hours and 18 minutes",
                                "yearly" => "3 days and 16 hours"
                            })),
    
    # Startend trigger
    '99% uptime' => test_zci("Implied downtimes for 99% uptime\n".
                            "Daily: 14 minutes and 24 seconds\n".
                            "Monthly: 7 hours and 18 minutes\n".
                            "Annually: 3 days and 16 hours",
                            structured_answer => build_list_structure("99%",{
                                "daily" => "14 minutes and 24 seconds",
                                "monthly" => "7 hours and 18 minutes",
                                "yearly" => "3 days and 16 hours"
                            })),

    # Decimal separator
    'uptime 99,99%' => test_zci("Implied downtimes for 99,99% uptime\n".
                            "Daily: 8 seconds\n".
                            "Monthly: 4 minutes and 22 seconds\n".
                            "Annually: 52 minutes and 35 seconds",
                            structured_answer => build_list_structure("99,99%",{
                                "daily" => "8 seconds",
                                "monthly" => "4 minutes and 22 seconds",
                                "yearly" => "52 minutes and 35 seconds"
                            })),
    'uptime 99.99%' => test_zci("Implied downtimes for 99.99% uptime\n".
                            "Daily: 8 seconds\n".
                            "Monthly: 4 minutes and 22 seconds\n".
                            "Annually: 52 minutes and 35 seconds",
                            structured_answer => build_list_structure("99.99%",{
                                "daily" => "8 seconds",
                                "monthly" => "4 minutes and 22 seconds",
                                "yearly" => "52 minutes and 35 seconds"
                            })),
    
    # Grouping allowed on input
    'uptime 99.999 999 999%' => test_zci("Implied downtimes for 99.999999999% uptime\n".
                            "No downtime or less than a second during a year",
                            structured_answer => build_text_structure("99.999999999%")),

    # Less than 100% uptime but close to no downtime
    'uptime 99.999999999%' => test_zci("Implied downtimes for 99.999999999% uptime\n".
                            "No downtime or less than a second during a year",
                            structured_answer => build_text_structure("99.999999999%")),

    # Some parts (but not all) are below 1 second
    'uptime 99.9999%' => test_zci("Implied downtimes for 99.9999% uptime\n".
                            "Daily: less than one second\n".
                            "Monthly: 2 seconds\n".
                            "Annually: 31 seconds",
                            structured_answer => build_list_structure("99.9999%",{
                                "daily" => "less than one second",
                                "monthly" => "2 seconds",
                                "yearly" => "31 seconds"
                            })),
    'uptime 99.99999%' => test_zci("Implied downtimes for 99.99999% uptime\n".
                            "Daily: less than one second\n".
                            "Monthly: less than one second\n".
                            "Annually: 3 seconds",
                            structured_answer => build_list_structure("99.99999%",{
                                "daily" => "less than one second",
                                "monthly" => "less than one second",
                                "yearly" => "3 seconds"
                            })),
                            
    # Lower limit
    'uptime 0%' => test_zci("Implied downtimes for 0% uptime\n".
                            "Daily: 1 day\n".
                            "Monthly: 30 days and 10 hours\n".
                            "Annually: 1 year and 6 hours",
                            structured_answer => build_list_structure("0%",{
                                "daily" => "1 day",
                                "monthly" => "30 days and 10 hours",
                                "yearly" => "1 year and 6 hours"
                            })),
    'uptime 000%' => test_zci("Implied downtimes for 000% uptime\n".
                            "Daily: 1 day\n".
                            "Monthly: 30 days and 10 hours\n".
                            "Annually: 1 year and 6 hours",
                            structured_answer => build_list_structure("000%",{
                                "daily" => "1 day",
                                "monthly" => "30 days and 10 hours",
                                "yearly" => "1 year and 6 hours"
                            })),

    # Outside range
    'uptime 101%' => undef,
    'uptime 100.00000000000000000000000000001%' => undef,
    'uptime -10%' => undef,
    'uptime -0.00000000000000000000000000001%' => undef,

    # Upper limit 100% is not allowed as it would return a tautology
    'uptime 100%' => undef,
    'uptime 100.00%' => undef,

    # Misc bad queries
    'uptime 99.99.99%' => undef,
    'uptime 99.99' => undef,
    'uptime ninety-nine' => undef,
    'up time 99%' => undef,
    'up time 99%%' => undef
);

done_testing;
