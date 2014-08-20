package DDG::Goodie::ZappBrannigan;
# ABSTRACT: Zapp Brannigan quotes.

use DDG::Goodie;

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

my @quotes = share('quotes.txt')->slurp;

handle query => sub {
	# Ensure rand is seeded for each process
	srand();
	
    return if $_ !~ m/quotes?/;
    my $rand = int(rand(scalar(@quotes)));
    my $quote = $quotes[$rand];
    chomp $quote;
    (my $text = $quote) =~ s/<br>/\n/g;
    return $text, html => $quote;
};

1;
