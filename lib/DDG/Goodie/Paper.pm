package DDG::Goodie::Paper;
# ABSTRACT: Return the dimensions of a defined paper size

use DDG::Goodie;
use YAML;

zci answer_type => "paper";
zci is_cached   => 1;

triggers any => 'paper size', 'dimensions', 'paper dimension', 'paper dimensions';

primary_example_queries 'letter paper size';
secondary_example_queries 'a1 paper size', 'a9 paper dimension';
description 'Lookup the size of standard paper sizes';
name 'Paper';
code_url
    'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Paper.pm';
category 'conversions';
topics 'special_interest';
attribution github => 'loganom',
            twitter => 'loganmccamon',
            github => 'mattlehnig';

my $sizes = Load(scalar share('sizes.yml')->slurp);

handle query_lc => sub {
    return unless my ($s, $l, $n) = $_ =~ /^((?:(a|b|c)(\d{0,2}))|legal|letter|junior\s*legal|ledger|tabloid|hagaki)\s+paper\s+(?:size|dimm?ensions?)$/i;

    my $value = $sizes->{$s};
    return unless $value;

    $s = uc $s if defined $n;

    return $value,
      structured_answer => {
        input     => [$s],
        operation => 'paper size',
        result    => $value
      };
};

1;
