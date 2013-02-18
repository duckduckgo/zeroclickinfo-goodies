package DDG::Goodie::AnagramSolver;

use DDG::Goodie;

# will need to select an appropriate trigger word
triggers start => "flargblarg";

handle remainder => sub {
    /^\s*([a-zA-Z]+)\s*([0-9]+)\s*$/;
    my $word = 0;
    $word = lc($1) if $word;
    my $n = 0;
    $n = $2 if $2;    

    my %freq;
    for (split //, $word) {
	if ($freq{$_}) {
	    $freq{$_} += 1;
	} else {
	    $freq{$_} = 1;
	}
    }

    # this dictionary access is potentially crap, but useful
    # for testing
    open INF, "<", "/usr/share/dict/words" or die $!; # PLACEHOLDER
    my @output;
    while (<INF>) { # PLACEHOLDER
	if ($word and /^[$word]{$n}$/) {
	    chomp;
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
    return join ", ", @output;
};

1;
