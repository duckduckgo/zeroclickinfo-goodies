#!/bin/env perl
package DDG::Goodie::SubnetCalc;
# ABSTRACT: Calculate IP ranges & Subnet Information from a host & CIDR or netmask 
use strict;
use warnings;

use DDG::Goodie;

# TODO: This (sh|c)ould be re-written to be more precise
triggers query => qr`^([0-9]{1,3}\.){3}([0-9]{1,3})[\s/](([1-3]?[0-9])|(([0-9]{1,3}\.){3}([0-9]{1,3})))$`;

zci answer_type => "subnet_info";
zci is_cached => 1;

attribution github => ['https://github.com/mintsoft', 'mintsoft'];

secondary_example_queries '46.51.197.88/255.255.254.0', '176.34.131.233/32';

category 'computing_tools';
topics 'sysadmin';

handle query => sub {
	sub int_to_str($) {
		my ($ip) = @_;
		return sprintf "%u.%u.%u.%u", ($ip>>24&0xff),($ip>>16&0xff),($ip>>8&0xff),($ip&0xff);
	}
	sub ip_to_int(@) {
		return (int($_[0])<<24) + (int($_[1])<<16) + (int($_[2])<<8) + (int($_[3]));
	}

	my ($input) = @_;
	my ($address,$cidr) = split qr`[\s/]`, $input;
	
	my @octlets = split /\./,$address;
	for (@octlets) {
		return if int($_)>255;
	}

	my $address_raw = ip_to_int(@octlets);
	my $wildcard_mask = 0;
	my $mask = 0;

	# Convert CIDR & Subnets
	if ($cidr =~ /^[0-9]+$/) {
		return if ($cidr>32 || $cidr<1);
		$wildcard_mask = 2**(32-$cidr)-1;	
		$mask = 0xffffffff ^ $wildcard_mask;
	}
	elsif ($cidr =~ /([0-9]{1,3}\.){3}([0-9]{1,3})/) {
		my @cidr_octlets = split /\./,$cidr;
		for(@cidr_octlets) {
			return if int($_)>255;
		}
	
		$mask = ip_to_int(@cidr_octlets);
		my $mask_binary = sprintf("%b",$mask);
		return unless ($mask_binary =~ /^1+0*$/);
		$wildcard_mask = 0xffffffff ^ $mask;
		$cidr = ($mask_binary =~ tr/1//);	#count number of 1's
	}
	else {
		return;
	}
	
	my $host = $address_raw & $wildcard_mask;
	my $network = $address_raw & $mask;
	
	my $start = $network+1;
	my $end = $network+($wildcard_mask-1);
	my $broadcast = $network+$wildcard_mask;
	my $host_count = 1+$end-$start;
	
	my $class = "A";
	$class = "E (reserved)" if (($network>>28 & 0x0F) == 0x0F);
	$class = "D (multicast)" if (($network>>28 & 0x0F) == 0x0E);
	$class = "C" if (($network>>29 & 0x07) == 0x06);
	$class = "B" if (($network>>30 & 0x03) == 0x02);
	
	my $which_specified = "Host #".($host);
	$which_specified = "Network" if ($host==0);
	$which_specified = "Broadcast" if ($host==$host_count+1);
	$which_specified = "Point-To-Point (".int_to_str($end).", ".int_to_str($start).")" if ($cidr==31);
	$which_specified = "Host Only" if ($cidr==32);
	
	my $output_str =	"Network: ".int_to_str($network)."/$cidr,".
					" Netmask: ".int_to_str($mask).",".
					" $which_specified specified,".
					" Class: $class";
	$output_str .=	", Host Address Range: ".int_to_str($start)."-".int_to_str($end).",".
					" $host_count Usable Addresses,".
					" Broadcast: ".int_to_str($broadcast)
					unless($cidr > 30);
	return $output_str;

};

1;