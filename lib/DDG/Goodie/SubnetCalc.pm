#!/bin/env perl
package DDG::Goodie::SubnetCalc;
# ABSTRACT: Calculate IP ranges & Subnet Information from a host & CIDR or netmask

use strict;
use warnings;

use DDG::Goodie;

my $ipv4 = qr#(?:[0-9]{1,3}\.){3}(?:[0-9]{1,3})#;

triggers query => qr#^$ipv4[\s/](?:(?:[1-3]?[0-9])|$ipv4)$#x;

zci answer_type => "subnet_calc";
zci is_cached => 1;

handle query => sub {
    my ($input) = @_;
    my ($address, $cidr) = split qr`[\s/]`, $input;

    my @octlets = split /\./, $address;
    for (@octlets) {
        return if int($_) > 255;
    }

    my $address_raw = ip_bytes_to_int(@octlets);
    my $wildcard_mask = 0;
    my $mask = 0;

    # Convert CIDR & Subnets
    if ($cidr =~ /^[0-9]+$/) {
        return if ($cidr > 32 || $cidr < 1);
        $wildcard_mask = 2**(32-$cidr) - 1;

        # Flip the bits.
        $mask = 0xffffffff ^ $wildcard_mask;
    } elsif ($cidr =~ /$ipv4/) {
        my @cidr_octlets = split /\./, $cidr;

        # An octlet cannot be over 255.
        for(@cidr_octlets) {
            return if int($_) > 255;
        }

        $mask = ip_bytes_to_int(@cidr_octlets);
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
    $which_specified = "Point-To-Point (".int_to_ip_str($end).", ".int_to_ip_str($start).")" if ($cidr == 31);
    $which_specified = "Host Only" if ($cidr == 32);

    my %output = (
        "Network" => int_to_ip_str($network) . "/$cidr (Class $class)",
        "Netmask" => int_to_ip_str($mask),
        "Specified" => "$which_specified",
    );

    my @output_keys = qw(Network Netmask Specified);

    unless($cidr > 30) {
        $output{"Host Address Range"} = int_to_ip_str($start) . "-" . int_to_ip_str($end) . " ($host_count hosts)";
        $output{"Broadcast"} = int_to_ip_str($broadcast);
        push @output_keys, "Host Address Range";
        push @output_keys, "Broadcast";
    }

    return to_text_answer(\%output, \@output_keys),
        structured_answer => {
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
                record_data => \%output,
                record_keys => \@output_keys,
            }
        };
};

# Convert an integer into an IP address.
sub int_to_ip_str {
    my ($ip) = @_;
    sprintf "%u.%u.%u.%u", $ip >> 24 & 0xff, $ip >> 16 & 0xff, $ip >> 8 & 0xff, $ip & 0xff;
}

# Convert an IP address into an integer.
sub ip_bytes_to_int {
    (int($_[0]) << 24) + (int($_[1]) << 16) + (int($_[2]) << 8) + int($_[3]);
}

sub to_text_answer
{
    my ($data, $keys) = @_;
    return join "\n", map {"$_: $data->{$_}";} @{$keys};
}

1;