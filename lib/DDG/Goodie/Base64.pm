package DDG::Goodie::Base64;

use DDG::Goodie;
use MIME::Base64; 
use Encode;

triggers startend => "base64";

zci answer_type => "base64_conversion";

zci is_cached => 1;

handle remainder => sub {
	return unless $_ =~ /^(encode|decode|)\s*(.*)$/i;

	my $command = $1 || '';
	my $str = $2 || '';

	if ($str) {

		if ( $command && $command eq 'decode' ) {

			$str = decode_base64($str);
			$str = decode( "UTF-8", $str );

			return "Base64 decoded: $str"; 
		}
		else {
			$str = encode_base64( encode( "UTF-8", $str ) );

			return "Base64 encoded: $str";
		}

	}

	return;
};

1;
