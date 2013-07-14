package DDG::Goodie::BioSeq;
# ABSTRACT: Does several simple string manipulations and transliterations, for the convienence of biologists designing primers and other simple tasks. Takes as arguments several functions, the shorthand of which is in the help.
use DDG::Goodie;

triggers start => 'bioseq';
handle remainder => sub {
	
	my $help = "To use the \"bioseq\" DDGoodie, enter a function name then the nucleotide or amino acid sequence.";
	$help .= "\n	r	reverse the sequence, return DNA";
	$help .= "\n	c	complement the sequence, return DNA";
	$help .= "\n	rc	reverse-complement the sequence, return DNA";
	$help .= "\n	tu	replace all T with U";
	$help .= "\n	tln	translate nucleotides to amino acids in three frames";
	$help .= "\n	t	estimate the melting temperature of sequence as DNA";
	$help .= "\n	w	estimate the DNA weight of sequence as DNA";
	$help .= "\nFor example, \"bioseq rc ATCGCGATUCGAT\" would return the reversed complementary sequence.";
	$help .= "\nFor example, \"bioseq tln ATCGCGATUCGAT\" would return the translation of the sequence.";
	
	my $nucleotides = "ATCGU";
	my $amino_acids = "FLSYCWPHQRIMTNKVADEG";
	
	my @tmp = split /\s+/, $_;	#Cut up argument
	my $function = lc(shift @tmp);	#Function is the first one
	if ($function eq "help"){return $help;}
	if ($function eq "h")	{return $help;}
	
	my $sequence = uc(join "", @tmp) if @tmp;	#The rest of argument should be seq, even with whitespace errors
	return unless $sequence;			#If no sequence, then quit and return nothing
	$sequence =~ s/[^$nucleotides$amino_acids]//;	#Delete all non-amino_acid/non-nucleotide characters
	$sequence =~ tr/U/T/;				#Make to DNA, for standardization, and since tu provides return to RNA
							#	also, T is an amino acid, U isn't
							
	#Awkward if list:
	if ($function eq "reverse")		{return "Reversed: ".scalar reverse $sequence;}	#Simple reverse in scalar context
	if ($function eq "r")			{return "Reversed: ".scalar reverse $sequence;}
	if ($function eq "complement")		{$sequence =~ tr/ATCGU/TAGCA/;return "Complement: ".$sequence;}	#Transliteration does complementing
	if ($function eq "c")			{$sequence =~ tr/ATCGU/TAGCA/;return "Complement: ".$sequence;}
	if ($function eq "reverse-complement")	{$sequence =~ tr/ATCGU/TAGCA/;return "Reversed complement: ".scalar reverse $sequence;}
	if ($function eq "rc")			{$sequence =~ tr/ATCGU/TAGCA/;return "Reversed complement: ".scalar reverse $sequence;}
	if ($function eq "translate")		{return "Translated to amino acid sequence:".translate($sequence);}
	if ($function eq "tln")			{return "Translated to amino acid sequence:".translate($sequence);}
	if ($function eq "tu")			{$sequence =~ tr/T/U/;return "T's turned to U's: ".$sequence;}	#Simple transliteration
	if ($function eq "temp")		{return "Estimated melting temperature of ".temp($sequence)." Celsius, supposing 50mM monovalent cations.";}
	if ($function eq "t")			{return "Estimated melting temperature of ".temp($sequence)." Celsius, supposing 50mM monovalent cations.";}
	if ($function eq "weight")		{return "That sequence, as DNA without a 5' phosphate, would weigh ".weight($sequence)." grams per mole.";}
	if ($function eq "w")			{return "That sequence, as DNA without a 5' phosphate, would weigh ".weight($sequence)." grams per mole.";}
	
	sub translate {
		return "[ERROR: Non-nucleotide characters detected]" if $_[0] =~ /[^ATCGU]/;
		my %tln_table = (	#Each amino acid is on a row, with codons that map to it
					"UUU"	=>	"F",	"UUC"	=>	"F",
					"UUA"	=>	"L",	"UUG"	=>	"L",
					"UCU"	=>	"S",	"UCC"	=>	"S",	"UCA"	=>	"S",	"UCG"	=>	"S", "AGU"	=>	"S",	"AGC"	=>	"S",
					"UAU"	=>	"Y",	"UAC"	=>	"Y",
					"UAA"	=>	"X",	"UAG"	=>	"X",	"UGA"	=>	"X",	
					"UGU"	=>	"C",	"UGC"	=>	"C",
					"UGG"	=>	"W",
					"CUU"	=>	"L",	"CUC"	=>	"L",	"CUA"	=>	"L",	"CUG"	=>	"L",
					"CCU"	=>	"P",	"CCC"	=>	"P",	"CCA"	=>	"P",	"CCG"	=>	"P",
					"CAU"	=>	"H",	"CAC"	=>	"H",
					"CAA"	=>	"Q",	"CAG"	=>	"Q",
					"CGU"	=>	"R",	"CGC"	=>	"R",	"CGA"	=>	"R",	"CGG"	=>	"R", "AGA"	=>	"R",	"AGG"	=>	"R",
					"AUU"	=>	"I",	"AUC"	=>	"I",	"AUA"	=>	"I",
					"AUG"	=>	"M",
					"ACU"	=>	"T",	"ACC"	=>	"T",	"ACA"	=>	"T",	"ACG"	=>	"T",
					"AAU"	=>	"N",	"AAC"	=>	"N",
					"AAA"	=>	"K",	"AAG"	=>	"K",
					"GUU"	=>	"V",	"GUC"	=>	"V",	"GUA"	=>	"V",	"GUG"	=>	"V",
					"GCU"	=>	"A",	"GCC"	=>	"A",	"GCA"	=>	"A",	"GCG"	=>	"A",
					"GAU"	=>	"D",	"GAC"	=>	"D",
					"GAA"	=>	"E",	"GAG"	=>	"E",
					"GGU"	=>	"G",	"GGC"	=>	"G",	"GGA"	=>	"G",	"GGG"	=>	"G"
				);
		$_[0] =~ tr/T/U/;	#Turn DNA to RNA
		my @frame;		#Make the three frames of reference
		$frame[0] = $frame[1] = $frame[2] = $_[0];	
		$frame[1] =~ s/^.//;	#Offset one by deletion
		$frame[2] =~ s/^..//;	#Offset two by deletion
		my @tln;
		my $start = 0;				#Frame currently open?
		foreach my $frame (0..$#frame) {	#For each of the frames
			$start = 0;			#We don't start until we see a start codon
			while ($frame[$frame]) {	#If there's still seq
				last unless $frame[$frame] =~ s/^(\w\w\w)//;	#Take 3 off the top
				if ($tln_table{$1} eq "X") {		#If stop indicated
					$tln[$frame] .= " {STOP} ";	# print stop
					$start = 0;			# and stop
					next;				# goto next codon
				}
				$tln[$frame] .= " {START} " and $start = 1 if !$start & $tln_table{$1} eq "M";	#start if we haven't yet
				$tln[$frame] .= $tln_table{$1};		#If we're not changing start status, we're normal, just add the amino acid
			}
		}
		my $report;				#make a report to return
		foreach my $frame (0..$#frame) {	# for each frame
			$report .= "\n\n\tFrame ".($frame+1).": $tln[$frame]" if $tln[$frame];	#Give me the title and the translation string, if it exists
		}
		return $report;
	}
	
	sub temp {
		return "[ERROR: Non-nucleotide characters detected]" if $_[0] =~ /[^ATCGU]/;
		my $gc_count = $_[0] =~ tr/CG/CG/;	#tr returns the number of transliterations it makes
		return (4 * $gc_count + 2 * ((scalar length $_[0]) - $gc_count)) if (scalar length $_[0]) < 14;
		#The above is for less than 14 length, below is for more than that
		return (64.9 + 41 * ($gc_count - 16.4) / scalar length $_[0]);
		#This formula is as cited in Promega's biomath page
		#http://www.promega.com/techserv/tools/biomath/calc11.htm
	}
	
	sub weight {
		return "[ERROR: Non-nucleotide characters detected]" if $_[0] =~ /[^ATCGU]/;
		my $g = $_[0] =~ tr/G/G/;	#Count each one individually
		my $c = $_[0] =~ tr/C/C/;
		my $a = $_[0] =~ tr/A/A/;
		my $t = $_[0] =~ tr/TU/TU/;	#Both count as T
		return ((329.2 * $g) + (313.2 * $a) + (304.2 * $t) + (289.2 * $c));
		#This formula is as cited in Promega's biomath page
		#http://www.promega.com/techserv/tools/biomath/calc11.htm
	}
};

zci is_cached => 1;

1;
