package DDG::Goodie::Frequency;
# ABSTRACT: Displays frequency of alphabet character (a-z)

use DDG::Goodie;

triggers start => 'frequency', 'freq';

primary_example_queries 'frequency of all characters in testing';
secondary_example_queries 'frequency of B in battle', 'frequency of all in testing 1234 ABC!';
description 'calculate the frequency of characters in a string';
name 'Frequency';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Frequency.pm';
category 'calculations';
topics 'geek';
attribution github => [ 'http://github.com/unlisted', 'Morgan' ];

handle remainder => sub {
    if ($_ =~ /^of ([a-z]|(?:all ?|)(?:letters|characters|chars|)) in (.+)/i)
    {

	my $collect = lc $1;
	my $target_str = lc $2;

#	warn qq($collect\t$target_str\n);

	my $count = 0;
	my %freq;
	my @chars = split //, $target_str;

	foreach (@chars)
	{
	    if ($_ =~ /[a-z]/)
	    {
		if ($collect =~ /all|letters|characters|chars/) { ++$freq{$_}; }
		else { ++$freq{$_} if $_ eq $collect; }

		++$count;
	    };
	};

	my @out;
	foreach my $key (keys %freq)
	{
	    push @out, join ":", $key, $freq{$key} . "/" . $count;
	};

	return "Frequency: " . join ' ',sort(@out) if @out;
    };

    return;
};

zci is_cached => 1;

1;
