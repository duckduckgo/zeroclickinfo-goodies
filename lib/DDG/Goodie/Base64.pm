package DDG::Goodie::Base64;
# ABSTRACT: Base64 <-> Unicode

use DDG::Goodie;

use MIME::Base64;
use Encode;

triggers startend => "base64";

zci answer_type => "base64_conversion";

zci is_cached => 1;

primary_example_queries 'base64 encode foo';
secondary_example_queries 'base64 decode dGhpcyB0ZXh0';
description 'encode to and decode from base64';
name 'Base64';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Base64.pm';
category 'conversions';
topics 'programming';
attribution web => [ 'robert.io', 'Robert Picard' ],
            github => [ 'http://github.com/rpicard', 'rpicard'],
            twitter => ['http://twitter.com/__rlp', '__rlp'];

handle remainder => sub {
	return unless $_ =~ /^(encode|decode|)\s*(.*)$/i;

	my $command = $1 || '';
	my $str = $2 || '';

	if ($str) {

		if ( $command && $command eq 'decode' ) {

			$str = decode_base64($str);
			$str = decode( "UTF-8", $str );
            chomp $str;

			return "Base64 decoded: $str"; 
		}
		else {
			$str = encode_base64( encode( "UTF-8", $str ) );
            chomp $str;

			return "Base64 encoded: $str";
		}

	}

	return;
};

1;
