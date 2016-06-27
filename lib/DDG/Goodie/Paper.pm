package DDG::Goodie::Paper;
# ABSTRACT: Return the dimensions of a defined paper size

use strict;
use DDG::Goodie;
use YAML::XS 'LoadFile';

zci answer_type => "paper";
zci is_cached   => 1;

triggers any => 'paper size', 'dimensions', 'paper dimension', 'paper dimensions';

my $sizes = LoadFile(share('sizes.yml'));

handle query_lc => sub {
    return unless my ($s, $l, $n) = $_ =~ /^((?:(a|b|c)(\d{0,2}))|legal|letter|junior\s*legal|ledger|tabloid|hagaki)\s+paper\s+(?:size|dimm?ensions?)$/i;

    my $value = $sizes->{$s};
    return unless $value;

    $s = uc $s if defined $n;

    return $value, structured_answer => {
        data => {
            title => $value,
            subtitle => "Paper size: $s"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
