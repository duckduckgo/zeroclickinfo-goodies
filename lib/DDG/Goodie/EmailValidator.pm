package DDG::Goodie::EmailValidator;
# ABSTRACT: Checks given email address

use strict;
use DDG::Goodie;
use Net::Domain::TLD;
use Email::Valid;

zci answer_type => 'email_validation';
zci is_cached   => 1;

triggers start => 'validate', 'validate my email', 'validate my e-mail';

my $message_part = {
    tldcheck         => 'top-level domain',
    fqdn             => 'fully qualified domain name',
    localpart	     => 'localpart',
    address_too_long => 'address length',
};

handle remainder => sub {
    return if !$_;

    $_ =~ /^([^\s]+@[^\s]+)$/g;
    my $address = $1;

    return if !$address;

    my $email_valid = Email::Valid->new(
        -tldcheck => 1,
    );

    # Danger: address returns possible modified string!
    my $result = $email_valid->address($address);

    my $message;
    if (!$result) {
        if (defined $message_part->{$email_valid->details}) {
            $message = "$address is invalid. Please check the $message_part->{$email_valid->details}.";
        }
        $message ||= "E-mail address $address is invalid.";
    } else {
        $message = "$address appears to be valid.";
    }

    return $message, structured_answer => {
        data => {
            title => $message,
            subtitle => "Email address validation: $address"
        },
        templates => {
            group => 'text'
        }
      };
};

1;
