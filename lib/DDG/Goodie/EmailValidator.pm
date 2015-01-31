package DDG::Goodie::EmailValidator;
# ABSTRACT: Checks given email address

use DDG::Goodie;
use Email::Valid;

primary_example_queries 'validate foo@example.com';
description 'Checks given email address.';
name 'Email';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EmailValidator.pm';
topics 'sysadmin';
category 'computing_info';

zci answer_type => 'email_validation';
zci is_cached   => 1;

triggers start => 'validate', 'validate my email', 'validate my e-mail';

attribution github  => ['https://github.com/stelim', 'Stefan Limbacher'],
            twitter => ['http://twitter.com/stefanlimbacher', 'Stefan Limbacher'];

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
            $message = "$address is invalid. Please check the " . $message_part->{$email_valid->details} . ".";
        }
        $message ||= 'E-mail address $address is invalid.';
    } else {
        $message = "$address appears to be valid.";
    }

    return $message,
      structured_answer => {
        input     => [html_enc($address)],
        operation => 'Email address validation',
        result    => html_enc($message),
      };
};

1;
