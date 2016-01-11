package DDG::Goodie::CryptHashCheck;
# ABSTRACT: Identifies cryptographic hash type.

use strict;
use DDG::Goodie; 

zci is_cached => 1;

# Only one trigger enabled.
triggers start => "hash";

my %cryptohash = (
    128 => "MD5",
    160 => "SHA-1",
    224 => "SHA-2/SHA-3",
    256 => "SHA-2/SHA-3",
    384 => "SHA-2/SHA-3",
    512 => "SHA-2/SHA-3"
);

my $wiki = "https://en.wikipedia.org/wiki/";

# Remainder function with links to the Wikipedia resources.
handle remainder => sub {

    return unless /^[0-9a-f]{32}$|^[0-9a-f]{40}$|^[0-9a-f]{56}$|^[0-9a-f]{64}$|^[0-9a-f]{96}$|^[0-9a-f]{128}$/i;
    
    my $chars = length $_;
    $chars *= 4;
 
    my $text = "This is a $chars bit " . $cryptohash{$chars} . " cryptographic hash."; 
    
    my $moretext;
    my $linkname = $cryptohash{$chars}; 
    
    if ($cryptohash{$chars} eq "SHA-2/SHA-3") {
        $moretext = [{ text => "SHA-3", href => $wiki . "SHA-3" }];
        $linkname = "SHA-2";
    }
    
    return $text,
    structured_answer => {
        id => 'crypt_hash_check',
        name => 'Answer',
        data => {
            title => $text,
        },
        meta => {
            sourceName => "Wikipedia " . $linkname,
            sourceUrl => "$wiki" . $linkname
        },
        templates => {
            group => 'text',
            options => {
                moreAt => 1,
                moreText => $moretext
            }
        }
    };

};

1;
