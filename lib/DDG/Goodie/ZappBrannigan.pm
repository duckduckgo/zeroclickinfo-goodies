package DDG::Goodie::ZappBrannigan;

use DDG::Goodie;
use YAML qw( LoadFile );

triggers any => "zapp", "brannigan";
zci is_cached => 0;

handle query => sub {
    my @quotes = share('quotes.txt')->slurp;
    my $rand = int(rand(scalar(@quotes)));
    my $quote = $quotes[$rand];
    chomp $quote;
    return $quote;
};

1;
