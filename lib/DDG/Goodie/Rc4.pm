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

name "DDG::Goodie::Rc4.pm";
description "Encrypt or decrypt a text using a key provided by the user";
primary_example_queries "crypto encrypt key string", "crypto decrypt key string";
secondary_example_queries "crypto en key string", "crypto de key string";
category "computing_tools";
topics "cryptography";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Rc4.pm";
attribution github => ["https://github.com/puskin94", "puskin94"],
            github => ["diegojuan", "JD"],
            web => "sysadminjd.com";

# Triggers
triggers startend => "rc4";

# Handle statement

handle remainder => sub { 

    (my $type, my $key, my $plaintext) = split / /;
    my $operation;
    my $result;

    return unless $type && $key && $plaintext;

    if ($type eq "encrypt" || $type eq "en" || $type eq "enc") {
            # To encrypt we receive the plaintext as is and pass it to the RC4 function.
            my $encrypted = RC4($key, $plaintext);
            # To avoid problems with non printable characters, we transform the result using encode_base64()
            $result = encode_base64($encrypted);
            chomp $result;
            $operation = "Rc4 Encryption";

    }
    if ($type eq "decrypt" || $type eq "de" || $type eq "dec") {
            #To decrypt we do the reverse process, we take the plaintext, transform it using decode_base64()
            my $decoded = decode_base64($plaintext);
            # Then we pass it to the RC4 funcion to be decrypted.
            $result = RC4($key, $decoded);
            # No need to encode again, this result is show as is.
            $operation = "Rc4 Decryption";
    }

    return $result,
        structured_answer => {
        input     => [],
        operation => $operation,
        result    => $result
    };

};

1;
