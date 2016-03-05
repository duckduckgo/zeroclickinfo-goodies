package DDG::Goodie::Rc4;
# ABSTRACT: This goddie provides a simple encription/decryption service
# using RC4 algorithm and a key provided by the user.

use DDG::Goodie;
use strict;
use warnings;
use Crypt::RC4;
use MIME::Base64;
with 'DDG::GoodieRole::WhatIs';

zci answer_type => "rc4";
zci is_cached   => 1;

# Triggers
triggers startend => "rc4";

my $matcher = wi_custom(
    groups  => ['command'],
    options => {
        command => qr/rc4 (?<type>(en|de)(c(crypt)?)?)\s+(?<key>.+)/i,
    },
);

# Handle statement

handle query => sub {
    my $query = shift;
    my $match = $matcher->full_match($query) or return;
    my $type  = $match->{type};
    my $key   = $match->{key};
    my $plaintext = $match->{primary};
    my $operation;
    my $result;

    if ($type =~ /^en/) {
            # To encrypt we receive the plaintext as is and pass it to the RC4 function.
            my $encrypted = RC4($key, $plaintext);
            # To avoid problems with non printable characters, we transform the result using encode_base64()
            $result = encode_base64($encrypted);
            chomp $result;
            $operation = "RC4 Encrypt";

    } elsif ($type =~ /^de/) {
            #To decrypt we do the reverse process, we take the plaintext, transform it using decode_base64()
            my $decoded = decode_base64($plaintext);
            # Then we pass it to the RC4 funcion to be decrypted.
            $result = RC4($key, $decoded);
            # No need to encode again, this result is show as is.
            $operation = "RC4 Decrypt";
    }

    return "$operation: $plaintext, with key: $key is $result",
    structured_answer => {
        operation => $operation,
        input => [html_enc($plaintext) . ", Key: $key"],
        result => $result
    };

};

1;
