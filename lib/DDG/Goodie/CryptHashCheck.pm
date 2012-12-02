package DDG::Goodie::CryptHashCheck;
# ABSTRACT: Identifies cryptographic hash function type.

use DDG::Goodie;

zci is_cached => 1;

triggers start => "hash","md5","sha";

primary_example_queries 'hash 624d420035fc9471f6e16766b7132dd6bb34ea62';
secondary_example_queries 'md5 1f9b59a2390bb77d2c446837d6aeab067f01b05732735f47099047cd7d3e9f85';
description 'Identifies cryptographic hash function type.';
name 'CryptHashCheck';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CryptHashCheck.pm';
category 'computing_tools';
topics 'cryptography';

attribution github => ['https://github.com/digit4lfa1l', 'digit4lfa1l'];


handle remainder => sub {
	my ($md5) = /^[0-9a-f]{32}$/i;
		return 'This is a MD5 cryptographic hash.' if $md5;
	my ($sha1)  = /^[0-9a-f]{40}$/i;
		return 'This is a SHA-1/40 cryptographic hash.' if $sha1;
	my ($sha224) = /^[0-9a-f]{56}$/i;
		return 'This is a SHA-2/224 cryptographic hash.' if $sha224;
	my ($sha256) = /^[0-9a-f]{64}$/i;
		return 'This is a SHA-2/256 cryptographic hash.' if $sha256;
	my ($sha384) = /^[0-9a-f]{96}$/i;
		return 'This is a SHA-2/384 cryptographic hash.' if $sha384;
	my ($sha512) = /^[0-9a-f]{128}$/i;
		return 'This is a SHA-2/512 cryptographic hash.' if $sha512; 
	return;	
};

1;
