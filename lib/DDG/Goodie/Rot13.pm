package DDG::Goodie::Rot13;
# ABSTRACT: Rotate chars by 13  letters

use DDG::Goodie;

primary_example_queries 'rot13 thirteen';
secondary_example_queries 'rot13 guvegrra';
description 'rotate all the letters in your query by 13';
name 'Rot13';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Rot13.pm';
category 'transformations';
topics 'cryptography';

attribution github => ['unlisted', 'Morgan'];

triggers start => 'rot13';

zci answer_type => 'rot13';
zci is_cached   => 1;

handle remainder => sub {
    my $in = shift;

    return unless $in;
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
