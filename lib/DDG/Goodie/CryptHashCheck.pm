package DDG::Goodie::CryptHashCheck;
# ABSTRACT: Identifies cryptographic hash type.

use DDG::Goodie;

# A comprehensive reference for hashing functions from Wikipedia.

use constant MD5HERF =>  "http://en.wikipedia.org/wiki/MD5#MD5_hashes";
use constant SHA1HREF => "http://en.wikipedia.org/wiki/SHA-1#Example_hashes";
use constant SHA2HREF => "http://en.wikipedia.org/wiki/SHA-2#Examples_of_SHA-2_variants";

zci is_cached => 1;

# Only one trigger enabled.
triggers start => "hash";

primary_example_queries 'hash 624d420035fc9471f6e16766b7132dd6bb34ea62';
secondary_example_queries 'hash 1f9b59a2390bb77d2c446837d6aeab067f01b05732735f47099047cd7d3e9f85';
description 'Identifies cryptographic hash function type.';
name 'CryptHashCheck';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CryptHashCheck.pm';
category 'computing_tools';
topics 'cryptography';

attribution github => ['https://github.com/digit4lfa1l', 'digit4lfa1l'];

# Remainder function with links to the Wikipedia resources. 

handle remainder => sub {
	my ($md5) = /^[0-9a-f]{32}$/i;
		if ($md5){
		  	my $text = sprintf qq(This is a MD5 cryptographic hash.);
  			my $html = sprintf qq(This is a <a href="%s">MD5</a> cryptographic hash.),MD5HERF;	
			
			return $text, html => $html;			
		}

	my ($sha1)  = /^[0-9a-f]{40}$/i;
		if ($sha1){
		  	my $text = sprintf qq(This is a SHA-1/40 cryptographic hash.);
  			my $html = sprintf qq(This is a <a href="%s">SHA-1/40</a> cryptographic hash.),SHA1HREF;	
			
			return $text, html => $html;			
		}
		
	my ($sha224) = /^[0-9a-f]{56}$/i;
		if ($sha224){
		  	my $text = sprintf qq(This is a SHA-2/224 cryptographic hash.);
  			my $html = sprintf qq(This is a <a href="%s">SHA-2/224</a> cryptographic hash.),SHA2HREF;	
			
			return $text, html => $html;			
		}

	my ($sha256) = /^[0-9a-f]{64}$/i;
		if ($sha256){
		  	my $text = sprintf qq(This is a SHA-2/256 cryptographic hash.);
  			my $html = sprintf qq(This is a <a href="%s">SHA-2/256</a> cryptographic hash.),SHA2HREF;	
			
			return $text, html => $html;			
		}

	my ($sha384) = /^[0-9a-f]{96}$/i;
		if ($sha384){
		  	my $text = sprintf qq(This is a SHA-2/384 cryptographic hash.);
  			my $html = sprintf qq(This is a <a href="%s">SHA-2/384</a> cryptographic hash.),SHA2HREF;	
			
			return $text, html => $html;			
		}

	my ($sha512) = /^[0-9a-f]{128}$/i;
		if ($sha512){
		  	my $text = sprintf qq(This is a SHA-2/512 cryptographic hash.);
  			my $html = sprintf qq(This is a <a href="%s">SHA-2/512</a> cryptographic hash.),SHA2HREF;	
			
			return $text, html => $html;			
		}
	return;	
};

1;
