package DDG::Goodie::Rc4;
# ABSTRACT: This goddie provides a simple encription/decryption service
# using RC4 algorithm and a key provided by the user.

use DDG::Goodie;
use strict;
use warnings;
use Crypt::RC4;
use MIME::Base64;

zci answer_type => "rc4";
zci is_cached   => 1;

# Triggers
triggers startend => "rc4";

# Handle statement

handle remainder => sub { 

    (my $type, my $key, my $plaintext) = split / /;
    my $operation;
    my $result;

    return unless $type && $key && $plaintext;

    if ($type =~ m/^en(c|crypt)?$/) {
            # To encrypt we receive the plaintext as is and pass it to the RC4 function.
            my $encrypted = RC4($key, $plaintext);
            # To avoid problems with non printable characters, we transform the result using encode_base64()
            $result = encode_base64($encrypted);
            chomp $result;
            $operation = "RC4 Encrypt";

    } elsif ($type =~ m/^de(c|crypt)?$/) {
            #To decrypt we do the reverse process, we take the plaintext, transform it using decode_base64()
            my $decoded = decode_base64($plaintext);
            # Then we pass it to the RC4 funcion to be decrypted.
            $result = RC4($key, $decoded);
            # No need to encode again, this result is show as is.
            $operation = "RC4 Decrypt";
    } else {
        return;
    }

    return "$operation: $plaintext, with key: $key is $result", structured_answer => {
        data => {
            title => $result,
            subtitle => "$operation: $plaintext, Key: $key"
        },
        templates => {
            group => 'text'
        }
    };

};

1;
