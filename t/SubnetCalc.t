#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'subnet_calc';
zci is_cached => 1;

sub build_structure
{
    my ($data, $keys) = @_;
    return {
        id => "subnet_calc",
        name => "Subnet Calculator",
        templates => {
            group => 'list',
            options => {
                content => 'record',
                moreAt => 0
            }
        },
        data => {
            title => 'IPv4 Subnet',
            record_data => $data,
            record_keys => $keys,
        }
    };
}

ddg_goodie_test(
    [
        # This is the name of the goodie that will be loaded to test.
        'DDG::Goodie::SubnetCalc'
    ],
    "10.0.0.0/24" => test_zci(
        "Network: 10.0.0.0/24 (Class A)\nNetmask: 255.255.255.0\nSpecified: Network\nHost Address Range: 10.0.0.1-10.0.0.254 (254 hosts)\nBroadcast: 10.0.0.255",
            structured_answer => build_structure({
                "Network" => "10.0.0.0/24 (Class A)",
                "Netmask" => "255.255.255.0",
                "Specified" => "Network",
                "Host Address Range" => "10.0.0.1-10.0.0.254 (254 hosts)",
                "Broadcast" => "10.0.0.255",
            }, ["Network", "Netmask", "Specified", "Host Address Range", "Broadcast"])
    ),

    "192.168.0.0/24" => test_zci(
        "Network: 192.168.0.0/24 (Class C)\nNetmask: 255.255.255.0\nSpecified: Network\nHost Address Range: 192.168.0.1-192.168.0.254 (254 hosts)\nBroadcast: 192.168.0.255",
            structured_answer => build_structure({
                "Network" => "192.168.0.0/24 (Class C)",
                "Netmask" => "255.255.255.0",
                "Specified" => "Network",
                "Host Address Range" => "192.168.0.1-192.168.0.254 (254 hosts)",
                "Broadcast" => "192.168.0.255",
            }, ["Network", "Netmask", "Specified", "Host Address Range", "Broadcast"])
    ),

    "8.8.8.8 255.255.224.0" => test_zci(
        "Network: 8.8.0.0/19 (Class A)\nNetmask: 255.255.224.0\nSpecified: Host #2056\nHost Address Range: 8.8.0.1-8.8.31.254 (8190 hosts)\nBroadcast: 8.8.31.255",
            structured_answer => build_structure({
                "Network" => "8.8.0.0/19 (Class A)",
                "Netmask" => "255.255.224.0",
                "Specified" => "Host #2056",
                "Host Address Range" => "8.8.0.1-8.8.31.254 (8190 hosts)",
                "Broadcast" => "8.8.31.255",
            }, ["Network", "Netmask", "Specified", "Host Address Range", "Broadcast"])
    ),
	
    '46.51.197.88/255.255.254.0' => test_zci(
        "Network: 46.51.196.0/23 (Class A)\nNetmask: 255.255.254.0\nSpecified: Host #344\nHost Address Range: 46.51.196.1-46.51.197.254 (510 hosts)\nBroadcast: 46.51.197.255",
            structured_answer => build_structure({
                "Network" => "46.51.196.0/23 (Class A)",
                "Netmask" => "255.255.254.0",
                "Specified" => "Host #344",
                "Host Address Range" => "46.51.196.1-46.51.197.254 (510 hosts)",
                "Broadcast" => "46.51.197.255",
            }, ["Network", "Netmask", "Specified", "Host Address Range", "Broadcast"])
	),

    '176.34.131.233/32' => test_zci(
        "Network: 176.34.131.233/32 (Class B)\nNetmask: 255.255.255.255\nSpecified: Host Only",
            structured_answer => build_structure({
            "Network" => "176.34.131.233/32 (Class B)",
            "Netmask" => "255.255.255.255",
            "Specified" => "Host Only",
        }, ["Network", "Netmask", "Specified"])
    ),
    
    '10.10.10.10/31' => test_zci(
        "Network: 10.10.10.10/31 (Class A)\nNetmask: 255.255.255.254\nSpecified: Point-To-Point (10.10.10.10, 10.10.10.11)",
            structured_answer => build_structure({
                "Network" => "10.10.10.10/31 (Class A)",
                "Netmask" => "255.255.255.254",
                "Specified" => "Point-To-Point (10.10.10.10, 10.10.10.11)",
        }, ["Network", "Netmask", "Specified"])
	),
);

done_testing;
