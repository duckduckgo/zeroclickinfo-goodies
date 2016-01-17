package DDG::Goodie::Rot13;
# ABSTRACT: Rotate chars by 13  letters

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';

triggers start => 'rot13';

zci answer_type => 'rot13';
zci is_cached   => 1;

my $matcher = wi_custom(
    groups => ['imperative', 'prefix'],
    options => {
        command => 'rot13',
    },
);

handle query => sub {
    my $query = shift;

    my $match = $matcher->full_match($query) or return;
    my $in = $match->{value};
    my $out = $in;

    $out =~ tr[a-zA-Z][n-za-mN-ZA-M];

    return "ROT13: $out",
      structured_answer => {
        input     => [html_enc($in)],
        operation => 'ROT13',
        result    => html_enc($out),
      };
};

1;
