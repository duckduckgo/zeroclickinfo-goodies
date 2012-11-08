package DDG::Goodie::ZappBrannigan;

use DDG::Goodie;
use YAML qw( LoadFile );

triggers any => "zapp", "brannigan";
zci is_cached => 0;

attribution github => ['http://github.com/nospampleasemam', 'nospampleasemam'],
            web => ['http://github.com/nospampleasemam', 'nospampleasemam'];

primary_example_queries 'zapp brannigan quote';
name 'Zapp Brannigan';
description 'retrieve a quote from the famous Zapp Brannigan';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ZappBrannigan.pm';
category 'entertainment';
topics 'entertainment';

handle query => sub {
    return if $_ !~ m/quotes?/;
    my @quotes = share('quotes.txt')->slurp;
    my $rand = int(rand(scalar(@quotes)));
    my $quote = $quotes[$rand];
    chomp $quote;
    (my $text = $quote) =~ s/<br>/\n/g;
    return $text, html => $quote;
};

1;
