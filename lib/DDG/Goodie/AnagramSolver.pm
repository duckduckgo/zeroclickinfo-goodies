package DDG::Goodie::AnagramSolver;

use DDG::Goodie;
use List::Util 'shuffle'; 

triggers start => "anagram", "anagrams";

handle remainder => sub {

    my $in = $_;
    my @output;

    if(/^\s*([a-zA-Z]+)\s*([0-9]+)?\s*$/) {
	my $word = lc($1);
	my $n = length $word;
	$n = $2 if $2 and ($2 <= $n && $2 > 0);

	my %freq;
	for (split //, $word) {
	    if ($freq{$_}) {
		$freq{$_} += 1;
	    } else {
		$freq{$_} = 1;
	    }
	}

	my $fileobj = share("words");
	open INF, "<", $fileobj->stringify or return;
	while (<INF>) {
	    if ($word and /^[$word]{$n}$/) {
		chomp;
		next if $_ eq $word;
		my %f;
		for (split //, $_) {
		    if ($f{$_}) {
			$f{$_} += 1;
		    } else {
			$f{$_} = 1;
		    }
		}
		
		my $it_works = 1;
		for (keys %f) {
		    if ($f{$_} >  $freq{$_}) {
			$it_works = 0;
			last;
		    }
		}
		push(@output, $_) if $it_works;
	    }
	}
    }
    return join(", ", @output) if @output; 

    my @chars = split(//, $in); #convert each character of the query to an array element
    my @garbledChars = shuffle(@chars); #randomly reorder the array
    my $garbledAnswer = join('',@garbledChars); #convert array to string
    return $garbledAnswer; 
};

zci is_cached => 0;

1;
