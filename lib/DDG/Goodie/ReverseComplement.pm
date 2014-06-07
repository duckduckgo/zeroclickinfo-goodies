package DDG::Goodie::ReverseComplement;
# ABSTRACT: Give the DNA reverse complement of a DNA or RNA sequence.

use DDG::Goodie;

triggers startend => 'reverse complement', 'revcomp';
zci is_cached => 0;

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

    #Return nothing if sequence contains both
    # thymine and uracil (more likely an error than a real molecule)
    return if $sequence =~ /T/ && $sequence =~ /U/;

    #Complement
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
  my $css = share("style.css")->slurp;
  return "<style type='text/css'>$css</style>$html";
}

sub wrap_html {
  my ($label, $sequence) = @_;
  return append_css("<div class='zci--reversecomplement'><span class='label'>$label</span> $sequence</div>");
}
1;
