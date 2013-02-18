package DDG::Goodie::AnagramSolver;

use DDG::Goodie;

# will need to select an appropriate trigger word
triggers start => "flargblarg";

handle remainder => sub {
    # maybe just split input and then test for validity
    # to make it more robust
    /^\s*([a-zA-Z]+)\s*([0-9]+)\s*$/;
    my $word = 0;
    $word = lc($1) if $1;
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

    my $fileobj = share("words");
    open INF, "<", $fileobj->stringify or return;
    my @output;
    while (<INF>) {
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
