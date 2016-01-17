package DDG::Goodie::Reverse;
# ABSTRACT: Reverse the order of chars in the remainder

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';

triggers startend => "reverse text";

zci answer_type => "reverse";
zci is_cached   => 1;

my $matcher = wi_custom(
    groups => ['imperative', 'prefix', 'postfix'],
    options => {
        command => 'reverse text',
        primary => qr/(?!complement\s(of )?[ATCGURYKMSWBVDHN\s-]+).+/i,
    },
);

handle query => sub {
  my $query = shift;
  my $match = $matcher->full_match($query) or return;

  #Filter out requests for DNA/RNA reverse complements, handled
  # by the ReverseComplement goodie
  my $in = $match->{value};

  my $out = reverse $in;

  return qq|Reversed "$in": | . $out,
    structured_answer => {
      input     => [html_enc($in)],
      operation => 'Reverse string',
      result    => html_enc($out),
    };
};

1;
