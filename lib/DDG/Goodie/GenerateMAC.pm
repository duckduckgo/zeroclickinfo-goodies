package DDG::Goodie::GenerateMAC;
#generates a random network MAC address

use DDG::Goodie;

triggers startend => "generate mac addr", 
					 "generate mac address", 
					 "random mac addr",
					 "random mac address",;

zci answer_type => "MAC Address";
zci is_cached => 0;

primary_example_queries 'please generate mac';
description 'generates a MAC address';
name "GenerateMAC";

attribution github => [ 'https://github.com/UnGround', 'Charlie Belmer' ],
			web => ['http://www.charliebelmer.com','Charlie Belmer'];

handle remainder => sub {
	my $address = join(':', map {sprintf '%0.2X', rand(255)}(1..6));
	my $more_info = qq(More information at <a href='http://coffer.com/mac_find/'>coffer.com</a>);
	return $address, html => "<i>Here's a random MAC address: </i>$address <br /> $more_info";
};

1;