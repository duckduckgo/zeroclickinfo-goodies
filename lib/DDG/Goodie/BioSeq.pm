package DDG::Goodie::BioSeq;
# ABSTRACT: Does several simple string manipulations, transliterations, and calculations, for lazy biologists designing primers and doing simple things. Takes as arguments several functions, the shorthand of which is in the help.
use DDG::Goodie;

#Trigger is just before the handle function

zci is_cached => 1;
zci answer_type => 'bioseq';

primary_example_queries 'ATGAAACCCGGGTAG';
secondary_example_queries 'AUGAUGUUCGGGUAG', 'QVRGLINE';
description 'Simple string manipulations and calculations for lazy biologists, requires 6 or more valid characters to start';
name 'BioSeq';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/lib/DDG/Goodie/BioSeq.pm';
category 'calculations';
topics 'science';
attribution email => ['chreod@???.???', 'chreod'];

my %tln_table = (	
	"UUU"	=>	"F",	"UUC"	=>	"F",
	"UUA"	=>	"L",	"UUG"	=>	"L",
	"UCU"	=>	"S",	"UCC"	=>	"S",	"UCA"	=>	"S",	"UCG"	=>	"S", "AGU"	=>	"S",	"AGC"	=>	"S",
	"UAU"	=>	"Y",	"UAC"	=>	"Y",
	"UAA"	=>	"Z",	"UAG"	=>	"Z",	"UGA"	=>	"Z",	#Stop codon is Z
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
my %amino_acid_weight = (	# from http://web.expasy.org/findmod/findmod_masses.html#AA , water from hydrolysis is already removed in this list
	"A"	=>	71.0788,
	"R"	=>	156.1875,
	"N"	=>	114.1038,
	"D"	=>	115.0886,
	"C"	=>	103.1388,
	"E"	=>	129.1155,
	"Q"	=>	128.1307,
	"G"	=>	57.0519,
	"H"	=>	137.1411,
	"I"	=>	113.1594,
	"L"	=>	113.1594,
	"K"	=>	128.1741,
	"M"	=>	131.1926,
	"F"	=>	147.1766,
	"P"	=>	97.1167,
	"S"	=>	87.0782,
	"T"	=>	101.1051,
	"W"	=>	186.2132,
	"Y"	=>	163.1760,
	"V"	=>	99.1326,
	"U"	=>	150.0388,
	"O"	=>	237.3018
);
my %oxy_nucleotide_weight = (	#RNA
	"A"	=>	347.22,
	"U"	=>	324.181,
	"G"	=>	363.22,
	"C"	=>	323.20,
);
my %deoxy_nucleotide_weight = (	#DNA
	"A"	=>	331.222,	
	"T"	=>	322.208,
	"U"	=>	308.182,	#dUMP for handling oligos during library prep
	"G"	=>	347.2243,
	"C"	=>	307.197,
);
my $amino_acids = lc(join("", keys(%amino_acid_weight)));	# aka lc "FLSYCWPHQRIMTNKVADEG"
my $oxy_nucleotides = lc(join("", keys(%oxy_nucleotide_weight)));
my $deoxy_nucleotides = lc(join("", keys(%deoxy_nucleotide_weight)));
my %tmphash;	#Use a hash to find uniques
@tmphash{(keys(%amino_acid_weight),keys(%oxy_nucleotide_weight),keys(%deoxy_nucleotide_weight))} = ();
my $valid = lc(join("", sort keys %tmphash));	#This is all the unique valid characters
undef %tmphash;
@tmphash{(keys(%oxy_nucleotide_weight),keys(%deoxy_nucleotide_weight))} = ();
my $nucleotides = lc(join("", sort keys %tmphash));	#This is all the unique valid nucleotide characters
undef %tmphash;

my %html_references = (
	"temperature"	=> '<a href="http://www.promega.com/techserv/tools/biomath/calc11.htm">Temperature formula from Promega</a>',
);

sub translate {
	return if $_[0] =~ /[^$nucleotides]/i;
	$_[0] = uc $_[0];	#Because I don't want to rewrite the codon table
	$_[0] =~ tr/T/U/; 	#Turn DNA to RNA for lookup table
	my @frame;		#Make the three frames of reference
	$frame[0] = $frame[1] = $frame[2] = $_[0];
	$frame[1] =~ s/^.//;  	#Offset one by deletion
	$frame[2] =~ s/^..//; 	#Offset two by deletion
	my @tln;
	my $start;				#Start with frame stopped
	foreach my $frame (0..$#frame) {	#For each of the frames
		$start = 0;			#We don't start until we see a start codon
		while ($frame[$frame]) {	#If there's still seq
			last unless $frame[$frame] =~ s/^(\w\w\w)//;	#Take 3 off the top
			if ($tln_table{$1} eq "Z") {			#If stop indicated
				$tln[$frame] .= " {STOP} ";		#	and print stop
				$start = 0;				#	and stop
				next;					#	goto next codon
			}
			$tln[$frame] .= " {START} " and $start = 1   	#Start if we haven't yet
				if !$start & $tln_table{$1} eq "M";
			$tln[$frame] .= $tln_table{$1};			# If we're not changing start status, we're normal, just add the amino acid
		}
	}
	my $report = "Translated your input sequence to amino acid sequence:";
	foreach my $frame (0..$#frame) {
		# Give me the title and the translation string, if it exists
		$report .= "\nFrame ".($frame+1).": $tln[$frame]" if $tln[$frame];
	}
	return $report."\n";
}
	
sub temp {					#Temperature
	return if $_[0] =~ /[^atcg]/;		#I only calculate for DNA
	my $gc_count = $_[0] =~ tr/cg/cg/;	#Count all the Gs and Cs
	my $temperature;
	if ((scalar length $_[0]) < 14) {
		$temperature = (4 * $gc_count + 2 * ((scalar length $_[0]) - $gc_count));
		# The above is for less than 14 length, below is for 14 or more
	} else {
		$temperature = (64.9 + 41 * ($gc_count - 16.4) / scalar length $_[0]);
	}
	$temperature = sprintf("%.2f", $temperature);
	$temperature = "Estimated melting temperature of ".$temperature;
	$temperature .= " Celsius, supposing 50mM monovalent cations";
	return $temperature."\n";
	#This formula is as cited in Promega's biomath page
	#	http://www.promega.com/techserv/tools/biomath/calc11.htm
	#Should upgrade to this more detailed model
	#	http://www.idtdna.com/Analyzer/Applications/Instructions/Default.aspx
}

sub weight {
	my $weighing_seq = $_[0];
	my $seq_type = $_[1] if $_[1];	#get type override if there
	my $weight = 0;
	if ($weighing_seq =~ /[^$nucleotides]/ or $seq_type eq "Amino Acid") {	#If it has non-nucleotides, it must be a protein, so use a different table
		foreach (split(//, $weighing_seq)) {
			$weight += $amino_acid_weight{uc $_};	#Water already removed in table
		}
		$weight += 18.01528;	#Adding the ends back on, weight of water
		$weight = sprintf("%.2f", $weight);
		$weight = "That amino acid sequence weighs about ".$weight;
		$weight	.= " dalton";
	} elsif ($weighing_seq =~ /t/i or $seq_type eq "DNA") {	#If it has at least one T, then it must be DNA, even with dU's
		foreach (split(//, $weighing_seq)) {
			$weight += $deoxy_nucleotide_weight{uc $_} - 18.01528;	#Removing H0 from 5' phosphate and H from 3' hydroxl
		}
		$weight += 18.01528 - 63.98 + 2.016;	#Adding 5' OH and 3' H back on, removing 5' phosphate
		$weight = sprintf("%.2f", $weight);
		$weight = "That 5' unphosphorylated single stranded DNA sequence weighs about ".$weight;
		$weight	.= " grams per mole";
	}
	else {	#If it only has AUCG, then it must be RNA, right?
		foreach (split(//, $weighing_seq)) {
			$weight += $oxy_nucleotide_weight{uc $_} - 18.01528;	#Removing H0 from 5' phosphate and hydrogen from 3' hydroxl
		}
		$weight += 18.01528 + 159.957418;	#Adding 5' OH and 3' H back on, adding 5' triphosphate
		$weight = sprintf("%.2f", $weight);
		$weight = "That 5' triphosphorylated single stranded RNA sequence weighs about ".$weight;
		$weight	.= " grams per mole";
	}
	return $weight."\n";
}

triggers query_clean => qr/[$valid]{6}/i;
	#Also, we could use some better regex examples

handle query_clean => sub {
	my $query = lc $_;	#query is now lower cased input, raw
	my $sequence;
	my $seq_type;		#What kind of sequence?
	if ($query =~ s/(?:\bprotein\b)|(?:\bamino\s*acid\b)//gi) {	#We look for override keywords  
		$seq_type = "Amino Acid";
	} elsif ($query =~ s/(?:\brna\b)//gi) {
		$seq_type = "RNA";
	} elsif ($query =~ s/(?:\bdna\b)//gi) {
		$seq_type = "DNA";
	}
	if (defined $seq_type) {	#If we found a keyword, we use that seq_type
		$query =~ /([$amino_acids]{6,})/ if $seq_type eq "Amino Acid";
		$query =~ /([$deoxy_nucleotides]{6,})/ if $seq_type eq "DNA";
		$query =~ /([$oxy_nucleotides]{6,})/ if $seq_type eq "RNA";
		$sequence = $1 if $1;	# and find the first contiguous sequence
		unless ($sequence) {
			$query =~ /([$valid]{6,})/;
			return unless $1;
			$sequence = $1;
			$sequence =~ tr/u/t/ if $seq_type eq "DNA";
			$sequence =~ tr/t/u/ if $seq_type eq "RNA";
		}
	} else {	#Otherwise, we find the first possible sequence >= 6
		$query =~ /([$valid]{6,})/;
		$sequence = $1;		# and infer the seq_type
		if ($sequence =~ /[^$nucleotides]/) {
			$seq_type = "Amino Acid";
		} elsif ($sequence =~ /u/) {
			$seq_type = "RNA";
		} elsif ($sequence =~ /[$deoxy_nucleotides]/) {
			$seq_type = "DNA";
		}	# and then find that contiguous sequence
	}
	$sequence =~ tr/atcgu/atcgt/ if $seq_type eq "DNA";	#Complement
	$sequence =~ tr/atcgu/aucgu/ if $seq_type eq "RNA";	#Complement
	my $answer;		#Now we start building our answer
	$answer .= "Recognized $seq_type sequence ".(uc $sequence)."...\n";
	if ($seq_type ne "Amino Acid") {
		$answer .="Reversed: ".(uc reverse $sequence)."\n";
		$sequence =~ tr/atcgu/tagca/ if $seq_type eq "DNA";	#Complement
		$sequence =~ tr/atcgu/uagca/ if $seq_type eq "RNA";	#Complement
		$answer .="Complement: ".(uc $sequence)."\n"
			."Reverse Complement: ".(uc reverse $sequence)."\n";
		$sequence =~ tr/atcgu/tagct/;	#Put back to original
	}
	$answer .= weight($sequence, $seq_type);
	$answer .= temp($sequence) if $seq_type eq "DNA";
	
	$answer .= translate($sequence) if $query =~ /(translat)|(tln)/;
	#~ "translate"		=> sub { translate($_) },
	
	my $answer_html = $answer;
	$answer_html .= $html_references{"temperature"} if $seq_type eq "DNA";
		#Add our reference if we did the temperature function
	$answer_html =~ s/\n/<br>/g if $answer_html;
		#Turn it into html answer as well
	return $answer, html => $answer_html if $answer;	#Return the whole lot
	return;	#For good measure
};

1;
