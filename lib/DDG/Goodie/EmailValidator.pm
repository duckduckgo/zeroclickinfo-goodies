package DDG::Goodie::EmailValidator;
# ABSTRACT: Checks given email address

use DDG::Goodie;
use Email::Valid;

topics 'sysadmin';
category 'computing_info';

zci is_cached => 0;
triggers start => 'validate';

primary_example_queries 'validate foo@example.com';

attribution github  => ['https://github.com/stelim', 'Stefan Limbacher'],
            twitter => ['http://twitter.com/stefanlimbacher', 'Stefan Limbacher'];

my $message_part = {
	tldcheck 		 => 'top-level domain',
	fqdn			 => 'fully qualified domain name',
	localpart		 => 'localpart',
	address_too_long => 'address length',
};

handle remainder => sub {
	return if !$_;

	$_ =~ /\b([^\s]+@[^\s]+)\b/g ;
	my $address = $1;

	return if !$address;
	
	my $email_valid = Email::Valid->new(
		-tldcheck => 1,
	);
	
	my $result = $email_valid->address($address);
	
	if (! $result) {

	  	my $message =  "$address is invalid. Please check the " . $message_part->{$email_valid->details} . "."
	  		if defined $message_part->{$email_valid->details};
	  	
	  	return $message || "E-mail address $address is not valid. ${\$email_valid->details} (see also: RFC 822)";
	}

	return "$address seems to be valid.";
};

1;
