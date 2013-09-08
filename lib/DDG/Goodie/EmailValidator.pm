package DDG::Goodie::EmailValidator;

use DDG::Goodie;
use Email::Valid;

topics 'sysadmin';
category 'computing_info';

triggers start => 'validate';

primary_example_queries 'validate foo@example.com';

attribution github  => ['https://github.com/stelim', 'Stefan Limbacher'],
            twitter => ['http://twitter.com/stefanlimbacher', 'Stefan Limbacher'];

my $message_part = {
	tldcheck => 'the top-level domain',
	mxcheck  => 'the hostname',
};

handle remainder => sub {
	return if !$_;

	$_ =~ /\b([^\s]+@[^\s]+)\b/g ;
	my $address = $1;

	return if !$address;

	unless(Email::Valid->address(
			-address  => $address,
			-rfc822   => 1,
			-mxcheck  => 1,
			-tldcheck => 1,
		)) {

	  	my $message =  "please check " . $message_part->{$Email::Valid::Details} 
	  		if defined $message_part->{$Email::Valid::Details};
	  	
	  	return $message || "mail address $address is not valid. (see also: RFC 822)";
	}

	return "$address seems to be valid.";
};

zci is_cached => 0;

1;