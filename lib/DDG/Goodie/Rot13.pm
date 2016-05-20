package DDG::Goodie::Rot13;
# ABSTRACT: Rotate chars by 13  letters

use strict;
use DDG::Goodie;

triggers start => 'rot13';

zci answer_type => 'rot13';
zci is_cached   => 1;

handle remainder => sub {
    my $in = shift;

    return unless $in;
    my $out = $in;

    $out =~ tr[a-zA-Z][n-za-mN-ZA-M];

    return "ROT13: $out", structured_answer => {
        data => {
            title => html_enc($out),
            subtitle => "ROT13: ".html_enc($in)
        },
        templates => {
            group => 'text'
        }
    };            
};

1;
