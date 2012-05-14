package DDG::Goodie::Frequency;
# ABSTRACT: Displays frequency of alphabet character (a-z)

use DDG::Goodie;

triggers start => 'frequency', 'freq';

handle remainder => sub {
    if ($_ =~ /^of ([a-z]|all) in (.*)/i)
    {
	my $collect = lc $1;
	my $target_str = lc $2;
	my $count = 0;
	my %freq;
	my @chars = split //, $target_str;



	foreach (@chars)
	{
	    if ($_ =~ /[a-z]/)
	    {
		if ($collect =~ /all/) { ++$freq{$_}; } 
		else { ++$freq{$_} if $_ eq $collect; }

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
