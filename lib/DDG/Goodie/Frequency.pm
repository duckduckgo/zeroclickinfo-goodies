package DDG::Goodie::Frequency;
# ABSTRACT: Displays frequency of each character

use DDG::Goodie;

triggers start => 'frequency';

handle remainder => sub {
    if ($_)
    {
	my %freq;
	my @chars = split //, "\L$_";

	foreach (@chars)
	{
	    ++$freq{$_} if $_ =~ /[a-z]/i;
	};
	
	my @out;
	foreach my $key (keys %freq)
	{
	    push @out, (join ":",$key,$freq{$key});
	    print "$freq{$key}\n";
	};

	return "FREQUENCY: " . join ' ',sort(@out) if @out;
    };

    return;
};

zci is_cached => 1;

1;
