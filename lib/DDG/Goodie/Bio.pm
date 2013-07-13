package DDG::Goodie::Bio;
# ABSTRACT: Does several simple bioinformatics manipulations.
use DDG::Goodie;

triggers start => 'bio';
handle remainder => sub {
	unless (/(\S+)\s+(.*)/) {
		return "I don't see a function and sequence seperated by a space, like so: \"bio rc ATCG\", try again. Try \"bio h\" or \"bio help\" to get more possible functions.";
	}
	my $function = lc($1);
	my $sequence = uc($2);
	$sequence =~ s/\s//;
	return "That sequence has non-\"AUCGT\" characters...?" if $sequence =~ /[^TUACG]/;
	my %complement = (	"A" => "T",
						"U" => "A",
						"T" => "A",
						"C" => "G",
						"G" => "C");
	
	if ("h" eq $function | "help" eq $function | "halp" eq $function | "fuck" eq $function) {
		return "Help function activated. So this DDG Goodie does a couple of things:
	r		Reverse the sequence
	c		Complement the sequence
	rc		Reverse and complement the sequence
	tln		Translate the sequence in three frames using standard table
	#PLANNED	temp	Calculate a rough melting temperature for the sequence";
	}
	if ("tln" eq $function) {
		$sequence =~ tr/T/U/;			#Assume that all Ts should be Us
		#BEFORE RELEASE CHECK THE FOOKIN TABLE AGAIN
		my %tln_table = (	"UUU"	=>	"F",	#Translation table in fancy 
							"UUC"	=>	"F",	#	long form
							"UUA"	=>	"L",
							"UUG"	=>	"L",
							"UCU"	=>	"S",
							"UCC"	=>	"S",
							"UCA"	=>	"S",
							"UCG"	=>	"S",
							"UAU"	=>	"Y",
							"UAC"	=>	"Y",
							"UAA"	=>	"X",
							"UAG"	=>	"X",
							"UGU"	=>	"C",
							"UGC"	=>	"C",
							"UGA"	=>	"X",
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
			$frame[0] = $sequence;			#1st
			$frame[1] = $frame[0];			#
			$frame[1] =~ s/^.//;			#Second is delete first character
			$frame[2] = $frame[1];			#
			$frame[2] =~ s/^.//;			#Third is delete first character
			my @tln;# = ("","","");			#Space for translation
			my $start = 0;					#Are we started translating yet?
			
			foreach my $frame (0..$#frame) {	#For each of the frames
				$start = 0;					#We're not starting quite yet
				while ($frame[$frame]) {							#If there's still seq
					last unless $frame[$frame] =~ s/^(\w\w\w)//;	#Take first 3
					if ($tln_table{$1} eq "X") {
						$tln[$frame] .= " {STOP} ";
						$start = 0;
						next;
					}
					$tln[$frame] .= " {START} " and $start = 1 if !$start & $tln_table{$1} eq "M";
					$tln[$frame] .= $tln_table{$1};
				}
			}
			my $report = "Translated, got:";		#make a report to return
			foreach my $frame (0..$#frame) {
				$report .= "\n\n\tFrame ".($frame+1).": $tln[$frame]" if $tln[$frame];
			}
			return $report;
		}
	if ("c" eq $function) {
		my $report = "";
		my @sequence = split "", $sequence;
		foreach (@sequence) {
			$report .= $complement{$_};
		}
		return "Complementary sequence: ".$report;
	}
	if ("r" eq $function) {
		return "Reverse sequence: ".scalar reverse $sequence;
	}
	if ("rc" eq $function) {
		my $report = "";
		my @sequence = split "", $sequence;
		foreach (@sequence) {
			$report .= $complement{$_};
		}
		return "Reverse-Complementary sequence: ".scalar reverse $report;
	}
	if ("temp" eq $function) {
		return "Temperature calc not written yet...\n";
	}
	return "I didn't recognize that bio function, why don't you try \"bio h\" for help.";
};

zci is_cached => 1;

1;
