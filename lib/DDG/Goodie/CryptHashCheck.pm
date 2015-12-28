package DDG::Goodie::CryptHashCheck;
# ABSTRACT: Identifies cryptographic hash type.

use strict;
use DDG::Goodie; 

zci is_cached => 1;

# Only one trigger enabled.
triggers start => "hash";

primary_example_queries 'hash 624d420035fc9471f6e16766b7132dd6bb34ea62';
secondary_example_queries 'hash 1f9b59a2390bb77d2c446837d6aeab067f01b05732735f47099047cd7d3e9f85';
description 'Identifies cryptographic hash function type.';
name 'CryptHashCheck';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CryptHashCheck.pm';
category 'computing_tools';
topics 'cryptography';

attribution github => ['https://github.com/digit4lfa1l', 'digit4lfa1l'],
            github => ["https://github.com/Mailkov", "Melchiorre Alastra"];

my %cryptohash = (
    128 => "MD5",
    160 => "SHA-1",
    224 => "SHA-2/SHA-3",
    256 => "SHA-2/SHA-3",
    384 => "SHA-2/SHA-3",
    512 => "SHA-2/SHA-3"
);

# Remainder function with links to the Wikipedia resources.
handle remainder => sub {

    return unless /^[0-9a-f]{32}$|^[0-9a-f]{40}$|^[0-9a-f]{56}$|^[0-9a-f]{64}$|^[0-9a-f]{96}$|^[0-9a-f]{128}$/i;
    
    my $chars = length $_;
    $chars *= 4;
 
    my $text = "This is a $chars bit " . $cryptohash{$chars} . " cryptographic hash."; 
    
    my $wiki = "https://en.wikipedia.org/wiki/";
    
    my @moretext;
    my $linkname = $cryptohash{$chars}; 
    
    if ($cryptohash{$chars} eq "SHA-2/SHA-3") {
        @moretext = {
            text => "SHA-3",
            href => $wiki . "SHA-3" 
        };
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
                moreText => \@moretext
            }
        }
    };

};

1;
