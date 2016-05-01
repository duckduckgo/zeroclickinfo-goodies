package DDG::Goodie::Reverse;
# ABSTRACT: Reverse the order of chars in the remainder

use strict;
use DDG::Goodie;

triggers startend => "reverse text";

zci answer_type => "reverse";
zci is_cached   => 1;

handle remainder => sub {
  my $in = $_;

  return unless $in;    # Guard against empty query.
  #Filter out requests for DNA/RNA reverse complements, handled
  # by the ReverseComplement goodie
  return if $in =~ /^complement\s(of )?[ATCGURYKMSWBVDHN\s-]+$/i;

  my $out = reverse $in;

  return qq|Reversed "$_": | . $out,
    structured_answer => {
      input     => [html_enc($in)],
      operation => 'Reverse string',
      result    => html_enc($out),
    };
};

1;
