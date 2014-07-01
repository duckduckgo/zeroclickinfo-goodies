package DDG::Goodie::ReverseComplement;
# ABSTRACT: Give the DNA reverse complement of a DNA or RNA sequence.

use DDG::Goodie;
use feature 'state';

triggers startend => 'reverse complement', 'revcomp';
zci is_cached => 1;

name 'Reverse Complement';
description 'Give the DNA reverse complement of a DNA or RNA sequence';
primary_example_queries 'revcomp AAAACCCGGT';
category 'transformations';
topics 'science';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ReverseComplement.pm';
attribution github => ['http://github.com/wilkox', 'wilkox'];

handle remainder => sub {

    #Remove 'of' if supplied
    $_ =~ s/^of\s//g;

    my $sequence = $_;

    #Remove whitespace and dashes and make uppercase
    $sequence =~ s/\s|-//g;
    $sequence = uc($sequence);

    #Return nothing if sequence contains characters
    # other than DNA/RNA bases or standard IUPAC ambiguity codes
    return if $sequence =~ /[^ATCGURYKMSWBVDHN]/;

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

    return $sequence, html => wrap_html('DNA reverse complement:', $sequence);
};

# This function adds some HTML and styling to our output
# so that we can make it prettier (copied from the Conversions
# goodie)
sub append_css {
  my $html = shift;
  state $css = share("style.css")->slurp;
  return "<style type='text/css'>$css</style>$html";
}

sub wrap_html {
  my ($label, $sequence) = @_;
  return append_css("<div class='zci--reversecomplement'><div class='label'>$label</div><div class='sequence'>$sequence</div></div>");
}
1;
