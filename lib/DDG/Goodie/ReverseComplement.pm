package DDG::Goodie::ReverseComplement;
# ABSTRACT: Give the DNA reverse complement of a DNA or RNA sequence.

use strict;
use DDG::Goodie;
use feature 'state';

triggers any => 'reverse complement', 'revcomp';

zci answer_type => 'reverse_complement';
zci is_cached   => 1;

handle remainder => sub {

    my $sequence = $_;
    
    #Remove extra words if supplied
    $sequence =~ s/\bof\b//gi;
    $sequence =~ s/\bsequence\b//gi;
    $sequence =~ s/\b[DR]NA\b//gi;
    $sequence =~ s/\bnucleotide\b//gi;
    #Remove whitespace and dashes and make uppercase
    $sequence =~ s/\s|-//g;
    $sequence = uc($sequence);
    #Return nothing if sequence does not contains characters or contains characters
    # other than DNA/RNA bases or standard IUPAC ambiguity codes
    return unless ($sequence =~ /^[ATCGURYKMSWBVDHN]+$/);
    my $normalized_seq = $sequence;
    #DNA contains thymine (T) but not uracil (U);
    # RNA contains U but not T (with some extremely
    # rare exceptions). Hence, if the sequence
    # contains both U and T it's more likely to be an
    # error than a real molecule so should return nothing.
    return if $sequence =~ /T/ && $sequence =~ /U/;
    
    #Complement, using standard IUPAC codes
    $sequence =~ tr/ATUCGRYKMBVHD/TAAGCYRMKVBDH/;
    
    #Reverse
    $sequence = reverse($sequence);
    
    return $sequence, structured_answer => {
        data => {
            title => $sequence,
            subtitle => "Nucleotide reverse complement: $normalized_seq"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
