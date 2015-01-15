package DDG::Goodie::SimpleEncryptionService::Crypto;
# ABSTRACT: This goddie provides a simple encription/decryption service
# using RC4 algorithm and a key provided by the user.
# Usage: crypto encrypt key text
#        crypto decrypt key text
# or the short form
#        crypto en key text
#        crypto de key text 
#
# This implementation uses the RC$ algorithm described here
# http://en.wikipedia.org/wiki/RC4
#
# Requires cpan install MIME::Base64
#
# Juan Diego - diego@linux.com
# 2014 
use DDG::Goodie;
use strict;
use warnings;
use Crypt::RC4;
use MIME::Base64;

zci answer_type => "simpleencryptionservice";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "DDG::Goodie::Crypto:SimpleEncryptionService.pm";
description "Encryp or decrypt a text using a key provided by the user";
primary_example_queries "crypto encrypt key string", "crypto decrypt key string";
secondary_example_queries "crypto en key string", "crypto de key string";
category "computing_tools";
topics "cryptography";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Crypto/SimpleEncryptionService.pm";
attribution github => ["diegojuan", "JD"],
    web => "sysadminjd.com";

# Triggers
triggers start => "rc4";

# Handle statement

handle remainder => sub { 

my @arguments = split / /, $_;
my $type = $arguments[0];
my $key       = $arguments[1];
my $plaintext = $arguments[2];

# Here we determine if we are going to encrypt or decrypt.
# There are 4 switches.
# "encrypt" or "en" to encrypt a string
if ($type eq "encrypt" || $type eq "en") {
        # To encrypt we receive the plaintext as is and pass it to the RC4 function.
        my $encrypted = RC4($key, $plaintext);
        # To avoid problems with non printable characters, we transform the result using encode_base64()
        my $encoded = encode_base64($encrypted);
        return "Encrypted string: $encoded";
} 

# "decrypt" or "de" to decrypt the string.
if ($type eq "decrypt" || $type eq "de") {
        #To decrypt we do the reverse process, we take the plaintext, transform it using decode_base64()
        my $decoded = decode_base64($plaintext);
        # Then we pass it to the RC4 funcion to be decrypted.
        my $decrypted = RC4($key, $decoded);
        # No need to encode again, this result is show as is.
        return "Decrypted string: $decrypted";
}
};

1;
