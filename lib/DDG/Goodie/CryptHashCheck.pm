package DDG::Goodie::CryptHashCheck;
# ABSTRACT: Identifies cryptographic hash type.

use DDG::Goodie;

# A comprehensive reference for hashing functions from Wikipedia.

use constant MD5HERF =>  "http://en.wikipedia.org/wiki/MD5";
use constant SHA1HREF => "http://en.wikipedia.org/wiki/SHA-1";
use constant SHA2HREF => "http://en.wikipedia.org/wiki/SHA-2";
use constant SHA3HREF => "http://en.wikipedia.org/wiki/SHA-3";

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
		  	my $text = sprintf qq(This is a 128 bit MD5 cryptographic hash.);
  			my $html = sprintf qq(This is a 128 bit <a href="%s">MD5</a> cryptographic hash.),MD5HERF;

			return $text, html => $html;
		}

	my ($sha1)  = /^[0-9a-f]{40}$/i;
		if ($sha1){
		  	my $text = sprintf qq(This is a 160 bit SHA-1 cryptographic hash.);
  			my $html = sprintf qq(This is a 160 bit <a href="%s">SHA-1</a> cryptographic hash.),SHA1HREF;

			return $text, html => $html;
		}

	my ($sha224) = /^[0-9a-f]{56}$/i;
		if ($sha224){
		  	my $text = sprintf qq(This is a 224 bit SHA-2/SHA-3 cryptographic hash.);
  			my $html = sprintf qq(This is a 224 bit <a href="%s">SHA-2</a>/<a href="%s">SHA-3</a> cryptographic hash.),SHA2HREF,SHA3HREF;

			return $text, html => $html;
		}

	my ($sha256) = /^[0-9a-f]{64}$/i;
		if ($sha256){
		  	my $text = sprintf qq(This is a 256 bit SHA-2/SHA-3 cryptographic hash.);
  			my $html = sprintf qq(This is a 256 bit <a href="%s">SHA-2</a>/<a href="%s">SHA-3</a> cryptographic hash.),SHA2HREF,SHA3HREF;

			return $text, html => $html;
		}

	my ($sha384) = /^[0-9a-f]{96}$/i;
		if ($sha384){
		  	my $text = sprintf qq(This is a 384 bit SHA-2/SHA-3 cryptographic hash.);
  			my $html = sprintf qq(This is a 384 bit <a href="%s">SHA-2</a>/<a href="%s">SHA-3</a> cryptographic hash.),SHA2HREF,SHA3HREF;

			return $text, html => $html;
		}

	my ($sha512) = /^[0-9a-f]{128}$/i;
		if ($sha512){
		  	my $text = sprintf qq(This is a 512 bit SHA-2/SHA-3 cryptographic hash.);
  			my $html = sprintf qq(This is a 512 bit <a href="%s">SHA-2</a>/<a href="%s">SHA-3</a> cryptographic hash.),SHA2HREF,SHA3HREF;

			return $text, html => $html;
		}
	return;
};

1;
