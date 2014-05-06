package DDG::Goodie::Anagram;

use DDG::Goodie;
use List::Util 'shuffle'; 

triggers start => "anagram", "anagrams";

zci is_cached => 0;
zci answer_type => "anagram";

primary_example_queries "anagram of filter";
secondary_example_queries "anagram filter 5";
description "find the anagram(s) of your query";
name "Anagram";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Anagram.pm";
category "transformations";
topics "words_and_games";

attribution github => ["https://github.com/beardlybread", "beardlybread"];

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
	open my $INF, "<", $fileobj->stringify or return;
	while (<$INF>) {
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

    # copied verbatim from Randagram.pm
    my @chars = split(//, $in);
    @chars = shuffle(@chars);
    my $garbledAnswer = '"'.$in.'" scrambled: '.join('',@chars);
    # end Randagram.pm

    if($full_word) {
	if(@output) {
	    my $ana = "Anagram of \"$in\": ";
	    $ana = "Anagrams of \"$in\": " if scalar(@output) > 1;
	    return $ana.join(', ', @output);
	}
	return $garbledAnswer if $in;
    }
    return "Anagrams of \"$in\" of size $n: ".join(', ', @output) if @output;
    return $garbledAnswer if $in;

    return;
};

1;
