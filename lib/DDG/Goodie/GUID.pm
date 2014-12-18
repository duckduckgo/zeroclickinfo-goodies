package DDG::Goodie::GUID;
# ABSTRACT: Generated a GUID on-demand.

use DDG::Goodie;
use Data::GUID;

my %guid = (
    'guid'                          => 0,
    'uuid'                          => 1,
    'globally unique identifier'    => 0,
    'universally unique identifier' => 1,
    'rfc 4122'                      => 0,
);

triggers start => keys %guid;

zci answer_type => "guid";
zci is_cached   => 0;

primary_example_queries 'guid';
secondary_example_queries 'uuid';
description 'generate a unique indentifier';
name 'GUID';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GUID.pm';
category 'computing_tools';
topics 'programming';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC',
            twitter => 'loganmccamon',
            github  => 'loganom';


handle remainder => sub {

    my $guid = Data::GUID->new;

    return unless $guid;

    return $guid->as_string,
      structured_answer => {
        input     => [],
        operation => 'random GUID',
        result    => $guid->as_string
      };
};

1;
