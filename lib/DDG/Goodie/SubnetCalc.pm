#!/bin/env perl
package DDG::Goodie::SubnetCalc;
# ABSTRACT: Calculate IP ranges & Subnet Information from a host & CIDR or netmask

use strict;
use warnings;

use DDG::Goodie;

# TODO: This (sh|c)ould be re-written to be more precise
triggers query => qr#^([0-9]{1,3}\.){3}([0-9]{1,3})[\s/](([1-3]?[0-9])|(([0-9]{1,3}\.){3}([0-9]{1,3})))$#;

zci answer_type => "subnet_info";
zci is_cached => 1;

attribution github => ['mintsoft', 'Rob Emery'];

primary_example_queries '10.92.24.0/22';
secondary_example_queries '46.51.197.88 255.255.254.0', '176.34.131.233/32';

category 'computing_tools';
topics 'sysadmin';
description 'calculates IPv4 subnets and range information';

handle query => sub {
    # Convert an integer into an IP address.
    sub int_to_str {
        my ($ip) = @_;
        sprintf "%u.%u.%u.%u", $ip >> 24 & 0xff, $ip >> 16 & 0xff, $ip >> 8 & 0xff, $ip & 0xff;
    }

    # Convert an IP address into an integer.
    sub ip_to_int {
        (int($_[0]) << 24) + (int($_[1]) << 16) + (int($_[2]) << 8) + int($_[3]);
    }

    my ($input) = @_;
    my ($address, $cidr) = split qr`[\s/]`, $input;

    my @octlets = split /\./, $address;
    for (@octlets) {
        return if int($_) > 255;
    }

    my $address_raw = ip_to_int(@octlets);
    my $wildcard_mask = 0;
    my $mask = 0;

    # Convert CIDR & Subnets
    if ($cidr =~ /^[0-9]+$/) {
        return if ($cidr > 32 || $cidr < 1);
        $wildcard_mask = 2**(32-$cidr) - 1;

        # Flip the bits.
        $mask = 0xffffffff ^ $wildcard_mask;
    } elsif ($cidr =~ /([0-9]{1,3}\.){3}([0-9]{1,3})/) {
        my @cidr_octlets = split /\./, $cidr;

        # An octlet cannot be over 255.
        for(@cidr_octlets) {
            return if int($_) > 255;
        }

        $mask = ip_to_int(@cidr_octlets);
        # Convert the integer into its binary representation.
        my $mask_binary = sprintf("%b", $mask);

        # The mask cannot have alternating 1s and 0s.
        return unless ($mask_binary =~ /^1+0*$/);

        # Flip the bits.
        $wildcard_mask = 0xffffffff ^ $mask;

        # Count the number of 1s.
        $cidr = ($mask_binary =~ tr/1//);
    } else {
        return;
    }

    my $host = $address_raw & $wildcard_mask;
    my $network = $address_raw & $mask;

    my $start = $network + 1;
    my $end = $network + ($wildcard_mask - 1);
    my $broadcast = $network + $wildcard_mask;
    my $host_count = 1 + $end - $start;

    # Check the class type of the IP address.
    my $class = "A";
    $class = "E (reserved)" if (($network >> 28 & 0x0F) == 0x0F);
    $class = "D (multicast)" if (($network >> 28 & 0x0F) == 0x0E);
    $class = "C" if (($network >> 29 & 0x07) == 0x06);
    $class = "B" if (($network >> 30 & 0x03) == 0x02);

    my $which_specified = "Host #".($host);
    $which_specified = "Network" if ($host == 0);
    $which_specified = "Broadcast" if ($host == $host_count+1);
    $which_specified = "Point-To-Point (".int_to_str($end).", ".int_to_str($start).")" if ($cidr == 31);
    $which_specified = "Host Only" if ($cidr == 32);

    sub to_html {
	my $results = "";
    my $minwidth = "70px";
	foreach my $result (@_) {
	    $results .= "<div><span class=\"subnet__label text--secondary\">$result->[0]: </span><span class=\"text--primary\">$result->[1]</span></div>";
        $minwidth = "140px" if $result->[0] eq "Host Address Range";
	}
	return $results . "<style> .zci--answer .subnet__label {display: inline-block; min-width: $minwidth}</style>";
    }

    sub to_text {
	my $results = "";
	foreach my $result (@_) {
	    $results .= "$result->[0]: $result->[1]\n";
	}
	return $results;
    }

    # We're putting them into an array because we want the output to be sorted.
    my @output = (
	["Network", int_to_str($network) . "/$cidr (Class $class)"],
	["Netmask", int_to_str($mask)],
	["Specified", "$which_specified"],
    );

    unless($cidr > 30) {
	push @output, (["Host Address Range", int_to_str($start) . "-" . int_to_str($end) . " ($host_count hosts)"],
		       ["Broadcast", int_to_str($broadcast)]);
    }

    return answer => to_text(@output), html => to_html(@output);
};

1;
