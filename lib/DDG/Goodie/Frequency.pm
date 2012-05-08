package DDG::Goodie::Frequency;
# ABSTRACT: Displays frequency of alphabet character (a-z)

use DDG::Goodie;

triggers start => 'frequency', 'freq';

handle remainder => sub {
    if ($_)
    {
	my %freq;
	my $count = 0;
	my @chars = split //, "\L$_";

	foreach (@chars)
	{
	    if ($_ =~ /[a-z]/i)
	    {
		++$freq{$_};
		++$count;
	    };
	};
	
	my @out;
	foreach my $key (keys %freq)
	{
	    push @out, join ":", $key, $freq{$key} . "/" . $count;
	};

	return "FREQUENCY: " . join ' ',sort(@out) if @out;
    };

    return;
};

zci is_cached => 1;

1;
