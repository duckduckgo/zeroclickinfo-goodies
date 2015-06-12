package DDG::Goodie::Bitsum;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

use Math::BigInt;

zci answer_type => "bitsum";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "Bitsum";
description "Computes the Hamming Weight / bit-wise sum of a decimal or hex number.";
primary_example_queries "bitsum 1023", "bitsum 0x789abcd";
secondary_example_queries "hammingweight 1023", "hw 1023";
category "programming";
topics "programming", "cryptography";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Bitsum.pm";
attribution github => ["kste", "Stefan Koelbl"],
            twitter => "kste_";

# Triggers
triggers start => "bitsum", "hammingweight", "hw";

# Handle statement
handle remainder => sub {
    
    # Return if input is no hex or decimal number
    return unless $_ =~ /(^0x[0-9a-f]+$)|(^\d+$)/i;

    my $n = $_;
    my $binstring;
    
    # Construct binary for both hex and decimal representations
    if( $n =~ /^0x/) {
        $n =~ s/0x//;
        $binstring = unpack ('B*', pack ('H*',$n));
    } else {
        $binstring = Math::BigInt->new($n)->as_bin();
    }
    
    # Count ones
    my $result = $binstring =~ tr/1/1/;
    
    return $result,
        structured_answer => {
            input     => [html_enc($_)],
            operation => 'Hamming Weight',
            result    => html_enc($result),
        };
};


1;
