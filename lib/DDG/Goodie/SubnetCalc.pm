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

primary_example_queries '10.1.2.3/25';
secondary_example_queries '46.51.197.88/255.255.254.0', '176.34.131.233/32';

category 'computing_tools';
topics 'sysadmin';

handle query => sub {
	sub ip2str($) {
		my ($ip) = @_;
		return sprintf "%u.%u.%u.%u", ($ip>>24&0xff),($ip>>16&0xff),($ip>>8&0xff),($ip&0xff);
	}
	sub array2long(@) {
		return (int($_[0])<<24) + (int($_[1])<<16) + (int($_[2])<<8) + (int($_[3]));
	}

	my ($input) = @_;
	my ($address,$cidr) = split qr`[\s/]`, $input;
	
	my @octlets = split /\./,$address;
	for (@octlets) {
		return if int($_)>255;
	}

	my $addressRaw = array2long(@octlets);
	my $cidrHostMaskRaw = 0;
	my $cidrRaw = 0;

	# Convert CIDR & Subnets
	if ($cidr =~ /^[0-9]+$/) {
		return if ($cidr>32 || $cidr<1);
		$cidrHostMaskRaw = 2**(32-$cidr)-1;	
		$cidrRaw = 0xffffffff ^ $cidrHostMaskRaw;
	}
	elsif ($cidr =~ /([0-9]{1,3}\.){3}([0-9]{1,3})/) {
		my @cidr_octlets = split /\./,$cidr;
		for(@cidr_octlets) {
			return if int($_)>255;
		}
	
		$cidrRaw = array2long(@cidr_octlets);
		my $cidrBinary = sprintf("%b",$cidrRaw);
		return unless ($cidrBinary =~ /^1+0*$/);
		$cidrHostMaskRaw = 0xffffffff ^ $cidrRaw;
		$cidr = ($cidrBinary =~ tr/1//);	#count number of 1's
	}
	else {
		return;
	}
	
	my $host = $addressRaw & $cidrHostMaskRaw;
	my $network = $addressRaw & $cidrRaw;
	
	my $start = $network+1;
	my $end = $network+($cidrHostMaskRaw-1);
	my $broadcast = $network+$cidrHostMaskRaw;
	my $hostCount = 1+$end-$start;
	
	my $whichSpecified = "Host #".($host);
	$whichSpecified = "Network" if ($host==0);
	$whichSpecified = "Broadcast" if ($host==$hostCount+1);
	$whichSpecified = "Point-To-Point (".ip2str($end).", ".ip2str($start).")" if ($cidr==31);
	$whichSpecified = "Host Only" if ($cidr==32);
	
	my $outputStr =	"Network: ".ip2str($network)."/$cidr,".
					" Netmask: ".ip2str($cidrRaw).",".
					" $whichSpecified specified";
	$outputStr .=	", Host Address Range: ".ip2str($start)."-".ip2str($end).",".
					" $hostCount Usable Addresses,".
					" Broadcast: ".ip2str($broadcast) 
					unless($cidr > 30);
	return $outputStr;

};

1;