package DDG::Goodie::ZappBrannigan;
# ABSTRACT: Zapp Brannigan quotes.

use strict;
use DDG::Goodie;

use YAML::XS 'LoadFile';

triggers any => "zapp", "brannigan";

zci answer_type => 'zapp_brannigan';
zci is_cached   => 0;

attribution github => ['nospampleasemam', 'Dylan Lloyd'],
            web    => ['nospampleasemam', 'Dylan Lloyd'];

primary_example_queries 'zapp brannigan quote';
name 'Zapp Brannigan';
description 'retrieve a quote from the famous Zapp Brannigan';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ZappBrannigan.pm';
category 'entertainment';
topics 'entertainment';

my $quotes = LoadFile(share('quotes.yml'));

handle query => sub {
    return unless $_ =~ m/quotes?/;

    # Ensure rand is seeded for each process
    srand();
    my @quote = @{$quotes->[int(rand(scalar(@$quotes)))]};

    return join("\n", @quote),
      structured_answer => {
        input     => [],
        operation => 'Zapp Brannigan quote',
        result    => join('<br>', @quote)};
};

1;
