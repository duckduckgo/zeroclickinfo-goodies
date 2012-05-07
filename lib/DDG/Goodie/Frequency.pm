package DDG::Goodie::Frequency;
# ABSTRACT: Displays frequency of each character

use DDG::Goodie;

triggers start => 'frequency';

handle remainder => sub {
    if ($_)
    {
	my %freq;
	my %perc;
	my @chars = split //, "\L$_";
	my $count = 0;

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
	    #$perc{$key} = $freq{$key} / $count;
	    #my $rec = join ":", $key, $freq{$key};
	    push @out, join " ", (join ":", $key, $freq{$key}),  ($freq{$key} / $count);
	};

	return "FREQUENCY: " . join ' ',sort(@out) if @out;
    };

    return;
};

zci is_cached => 1;

1;
