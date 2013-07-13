package DDG::Goodie::Bio;
# ABSTRACT: Does several dirt simple bioinformatics manipulations, for convienence.
use DDG::Goodie;

triggers start => 'bio';
handle remainder => sub {
	unless (/(\S+)\s+(.*)/) {
		return "I don't see a function and sequence seperated by a space, like so: \"bio rc ATCG\", try again. Try \"bio h\" or \"bio help\" to get more possible functions.";
	}
	my $function = lc($1);	#To make matching easier
	my $sequence = uc($2);	#To make lookups standard
	$sequence =~ s/\s//;	#I'm assuming everything after a function 
							# identifier is just sequence
	return "That sequence has non-\"AUCGT\" characters...?" 
		if $sequence =~ /[^TUACG]/;	#And if it ain't sequence, I don't
									# want to deal with it
	my %complement = (	"A" => "T",	#Turns everything to ATCG complement
						"U" => "A",
						"T" => "A",
						"C" => "G",
						"G" => "C");
	
	if ("h" eq $function | "help" eq $function | "halp" eq $function) {
		return "Help function activated. So this DDG Goodie does a couple of things:
	r		Reverse the sequence
	c		Complement the sequence
	rc		Reverse and complement the sequence
	tln		Translate the sequence in three frames using standard table";
	}
	if ("tln" eq $function) {
		$sequence =~ tr/T/U/;			#Assume dealing with DNA
		my %tln_table = (	"UUU"	=>	"F",	#Translation table
							"UUC"	=>	"F",
							"UUA"	=>	"L",
							"UUG"	=>	"L",
							"UCU"	=>	"S",
							"UCC"	=>	"S",
							"UCA"	=>	"S",
							"UCG"	=>	"S",
							"UAU"	=>	"Y",
							"UAC"	=>	"Y",
							"UAA"	=>	"X",	#Stop codons are X
							"UAG"	=>	"X",	#Stop codons are X
							"UGU"	=>	"C",
							"UGC"	=>	"C",
							"UGA"	=>	"X",	#Stop codons are X
							"UGG"	=>	"W",
							"CUU"	=>	"L",
							"CUC"	=>	"L",
							"CUA"	=>	"L",
							"CUG"	=>	"L",
							"CCU"	=>	"P",
							"CCC"	=>	"P",
							"CCA"	=>	"P",
							"CCG"	=>	"P",
							"CAU"	=>	"H",
							"CAC"	=>	"H",
							"CAA"	=>	"Q",
							"CAG"	=>	"Q",
							"CGU"	=>	"R",
							"CGC"	=>	"R",
							"CGA"	=>	"R",
							"CGG"	=>	"R",
							"AUU"	=>	"I",
							"AUC"	=>	"I",
							"AUA"	=>	"I",
							"AUG"	=>	"M",
							"ACU"	=>	"T",
							"ACC"	=>	"T",
							"ACA"	=>	"T",
							"ACG"	=>	"T",
							"AAU"	=>	"N",
							"AAC"	=>	"N",
							"AAA"	=>	"K",
							"AAG"	=>	"K",
							"AGU"	=>	"S",
							"AGC"	=>	"S",
							"AGA"	=>	"R",
							"AGG"	=>	"R",
							"GUU"	=>	"V",
							"GUC"	=>	"V",
							"GUA"	=>	"V",
							"GUG"	=>	"V",
							"GCU"	=>	"A",
							"GCC"	=>	"A",
							"GCA"	=>	"A",
							"GCG"	=>	"A",
							"GAU"	=>	"D",
							"GAC"	=>	"D",
							"GAA"	=>	"E",
							"GAG"	=>	"E",
							"GGU"	=>	"G",
							"GGC"	=>	"G",
							"GGA"	=>	"G",
							"GGG"	=>	"G");
			my @frame;						#Make the three frames
			$frame[0] = $sequence;			#1st is just sequence
			$frame[1] = $frame[0];			#
			$frame[1] =~ s/^.//;			#Second is delete first 
			$frame[2] = $frame[1];			# character
			$frame[2] =~ s/^.//;			#Third is delete first 
			my @tln;						# character
			my $start = 0;					#Currently translating?
			
			foreach my $frame (0..$#frame) {#For each of the frames
				$start = 0;					#We're not started quite yet
				while ($frame[$frame]) {	#If there's still seq
					last unless $frame[$frame] =~ s/^(\w\w\w)//; #Take 3
					if ($tln_table{$1} eq "X") {	#If stop indicated
						$tln[$frame] .= " {STOP} ";	#Print it
						$start = 0;					# and stop
						next;
					}
					$tln[$frame] .= " {START} " and $start = 1 
						if !$start & $tln_table{$1} eq "M";	#start if we
															# haven't
					$tln[$frame] .= $tln_table{$1};	#Normal lookup
				}
			}
			my $report = "Translated, got:";	#make a report to return
			foreach my $frame (0..$#frame) {	# for each frame
				$report .= "\n\n\tFrame ".($frame+1).": $tln[$frame]"
					if $tln[$frame];
			}
			return $report;
		}
	if ("c" eq $function) {
		my $report = "";
		my @sequence = split "", $sequence;
		foreach (@sequence) {			#Look up each element of seq
			$report .= $complement{$_};	# and return the complements
		}
		return "Complementary sequence: ".$report;
	}
	if ("r" eq $function) {
		return "Reverse sequence: ".scalar reverse $sequence; #Reverse
	}
	if ("rc" eq $function) {
		my $report = "";
		my @sequence = split "", $sequence;
		foreach (@sequence) {
			$report .= $complement{$_};
		}
		return "Reverse-Complementary sequence: ".scalar reverse $report;
			#Do both reverse and complement, inefficiently written
	}
	if ("temp" eq $function) {
		return "Temperature calc not written yet...\n";
	}
	return "I didn't recognize that bio function, why don't you try \"bio h\" for help.";
		#Well, if I didn't see a function that matched, you should get
		# some help
};

zci is_cached => 1;

1;
