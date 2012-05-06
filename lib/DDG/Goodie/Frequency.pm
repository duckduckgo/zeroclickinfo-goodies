package DDG::Goodie::Frequency;
# ABSTRACT: Displays frequency of each character

use DDG::Goodie;

triggers start => 'frequency';

handle remainder => sub {
    if ($_)
    {
	my %freq;
	
	my $lower = lc;
	my @chars = split //,$lower;
	
	foreach my $char (@chars)
	{
	    ++$freq{$char} unless $_ eq ' ';
	};
	
	return "FREQUENCY: " . keys %freq if $_;
    };

    return;
};

zci is_cached => 1;

1;
