package DDG::Goodie::Anagram;

use DDG::Goodie;
use List::Util 'shuffle'; 

triggers start => "anagram", "anagrams";

handle remainder => sub {

    s/^of\s(.*)/$1/i;
    my $in = $_;
    my $n;
    my @output;
    my $full_word = 1;

    if(/^\s*([a-zA-Z]+)\s*([0-9]+)?\s*$/) {
	my $word = lc($1);
	$in = $word;
	$n = length $word;
	$n = $2 if ($2 && $2 <= $n && $2 > 0);
	$full_word = 0 if $n != length($word);

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
	    if ($word and /^[$word]{$n}$/i) {
		chomp;
		next if lc($_) eq lc($word);
		my %f;
		for (split //, lc($_)) {
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
    # copied verbatim from Anagram.pm
    my @chars = split(//, $in);
    @chars = shuffle(@chars);
    my $garbledAnswer = '"'.$in.'" scrambled: '.join('',@chars);
    # end Anagram.pm

    if($full_word) {
	if(@output) {
	    my $ana = "anagram: ";
	    $ana = "anagrams: " if scalar(@output) > 1;
	    return $ana.join(', ', @output);
	}
	return $garbledAnswer;
    }
    return "Anagrams of $in of size $n: ".join(', ', @output) if @output;
    return $garbledAnswer;
};

zci is_cached => 0;

1;
