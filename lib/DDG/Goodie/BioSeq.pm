package DDG::Goodie::BioSeq;
# ABSTRACT: Does several simple string manipulations and transliterations, for the convienence of biologists designing primers and other simple tasks. Takes as arguments several functions, the shorthand of which is in the help.
use DDG::Goodie;

triggers start => 'bioseq', 'bio';

zci is_cached => 1;
zci answer_type => 'bioseq';

primary_example_queries 'bioseq rc ATCG';
secondary_example_queries 'bioseq tln ATGAAACCCGGGTAG', 'bioseq temp TAATACGACTCACTATAGGG';
description 'simple string manipulations and calculations for lazy biologists, try bioseq help';
name 'BioSeq';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/lib/DDG/Goodie/BioSeq.pm';
category 'calculations';
topics 'science';
attribution email => ['chreod@lavabit.com', 'Darach Miller'];

my $help = "To use the \"bioseq\" DDGoodie, enter a function name then the nucleotide or amino acid sequence."
         . "\n	r	reverse the sequence, return DNA"
         . "\n	c	complement the sequence, return DNA"
         . "\n	rc	reverse-complement the sequence, return DNA"
         . "\n	tu	replace all T with U"
         . "\n	tln	translate nucleotides to amino acids in three frames"
         . "\n	t	estimate the melting temperature of sequence as DNA"
         . "\n	w	estimate the weight of sequence of nucleotides or protein"
         . "\nFor example, \"bioseq rc ATCGCGATUCGAT\" would return the reversed complementary sequence."
         . "\nFor example, \"bioseq tln ATCGCGATUCGAT\" would return the translation of the sequence.";
my $help_html = $help;
$help_html =~ s/\n/<br>/g;

my %tln_table = (
    #Each amino acid is on a row, with codons that map to it
    #Stop codon is ampersand
    #Need to add attribution for the codon table to IUPAC website
    "UUU"	=>	"F",	"UUC"	=>	"F",
    "UUA"	=>	"L",	"UUG"	=>	"L",
    "UCU"	=>	"S",	"UCC"	=>	"S",	"UCA"	=>	"S",	"UCG"	=>	"S", "AGU"	=>	"S",	"AGC"	=>	"S",
    "UAU"	=>	"Y",	"UAC"	=>	"Y",
    "UAA"	=>	"@",	"UAG"	=>	"@",	"UGA"	=>	"@",
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
my %amino_acid_weight = (
	#http://web.expasy.org/findmod/findmod_masses.html#AA
	#Water is already removed in this list
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
my %nucleotide_weight = (
	#From wikipedia chemical box
	"dA"	=>	331.222,	#d is for deoxy, so dna
	"dT"	=>	322.208,
	"dU"	=>	308.182,
	"dG"	=>	347.2243,
	"dC"	=>	307.197,
	"A"	=>	0,
	"T"	=>	0,
	"U"	=>	0,
	"G"	=>	0,
	"C"	=>	0,
);
my $amino_acids = join("", keys(%amino_acid_weight));	# aka "FLSYCWPHQRIMTNKVADEG"
$amino_acids =~ s/X//g;	#Two steps so that if we use a non-canonical table above, we can still get our string of possible nucleotides
my $nucleotides = join("", keys(%nucleotide_weight));
#apply nucleotides to below ^ statements?
#how complement I

my %functions = (
    "reverse"            => sub { "Reversed: ".reverse },
    "r"                  => sub { "Reversed: ".reverse },
    "complement"         => sub { return if /[^ATCG]/; tr/ATCGU/TAGCA/; "Complement: $_" },
    "c"                  => sub { return if /[^ATCG]/; tr/ATCGU/TAGCA/; "Complement: $_" },
    "reverse-complement" => sub { return if /[^ATCG]/; tr/ATCGU/TAGCA/; "Reversed complement: ".reverse },
    "rc"                 => sub { return if /[^ATCG]/; tr/ATCGU/TAGCA/; "Reversed complement: ".reverse },
    "tu"                 => sub { return if /[^$nucleotides]/; tr/T/U/; "T's turned to U's: $_" },
    "ut"                 => sub { return if /[^$nucleotides]/; tr/U/T/; "U's turned to T's: $_" },
    "translate"          => sub { translate($_) },
    "tln"                => sub { translate($_) },    
    "temp"               => sub { temp($_) },
    "t"                  => sub { temp($_) },
    "weight"             => sub { weight($_) },
    "w"                  => sub { weight($_) },
);

sub translate {
    return "BioSeq Error: Can't translate non-nucleotide characters" if $_[0] =~ /[^$nucleotides]/;
    $_[0] =~ tr/T/U/; # Turn DNA to RNA for lookup table
    my @frame;        # Make the three frames of reference
    $frame[0] = $frame[1] = $frame[2] = $_[0];
    $frame[1] =~ s/^.//;  # Offset one by deletion
    $frame[2] =~ s/^..//; # Offset two by deletion
    my @tln;
    my $start = 0;                                       # Frame currently open?
    foreach my $frame (0..$#frame) {                     # For each of the frames
        $start = 0;                                      # We don't start until we see a start codon
        while ($frame[$frame]) {                         # If there's still seq
            last unless $frame[$frame] =~ s/^(\w\w\w)//; # Take 3 off the top
            if ($tln_table{$1} eq "@") {                 # If stop indicated
                $tln[$frame] .= " {STOP} ";              # print stop
                $start = 0;                              # and stop
                next;                                    # goto next codon
            }
            $tln[$frame] .= " {START} " and $start = 1   # start if we haven't yet
                if !$start & $tln_table{$1} eq "M";
            $tln[$frame] .= $tln_table{$1};              # If we're not changing start status, we're normal, just add the amino acid
        }
    }
    my $report = "Translated your input sequence to amino acid sequence:";
    foreach my $frame (0..$#frame) {
        # Give me the title and the translation string, if it exists
        $report .= "\nFrame ".($frame+1).": $tln[$frame]" if $tln[$frame];
    }
    return $report;
}
	
sub temp {
	return "BioSeq Error: Can't calculate temperature for non-nucleotide sequence (doesn't support IUPAC codes)" if $_[0] =~ /[^ATCGU]/;
	#I can only calculate temperature for nucleotides
	my $gc_count = $_[0] =~ tr/CG/CG/;	#Count all the Gs and Cs
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
	return $temperature;
	# This formula is as cited in Promega's biomath page
	# http://www.promega.com/techserv/tools/biomath/calc11.htm
	#Should upgrade to dope formula
	#http://www.idtdna.com/Analyzer/Applications/Instructions/Default.aspx
}

sub weight {
	my $weighing_seq = $_[0];
	my $weight = 0;
	if ($weighing_seq =~ /[^$nucleotides]/) {
		#If it has non-nucleotides, it must be a protein, so use a different table
		foreach (split(//, $weighing_seq)) {
			$weight += $amino_acid_weight{$_};	#Water already removed in table
		}
		$weight += 18.01528;	#Adding the ends back on
		$weight = sprintf("%.2f", $weight);
		$weight = "That amino acid sequence weighs about ".$weight;
		$weight	.= " dalton";
	} elsif (/DERP/) {	#assume rna?
		
	} else {
		foreach (split(//, $weighing_seq)) {
			$weight += $nucleotide_weight{"d".$_} - 18.01528;	#Removing H0 from phosphate and hydrogen from 3' hydroxl
		}
		$weight += 18.01528 - 63.98 + 2.016;	#Adding 5' OH and 3' H back on, removing 5' phosphate
		$weight = sprintf("%.2f", $weight);
		$weight = "That 5' phosphorylated nucleotide sequence weighs about ".$weight;
		$weight	.= " grams per mole";
	}
	return $weight;
	#This formula is as cited in Promega's biomath page
	#http://www.promega.com/techserv/tools/biomath/calc11.htm
}


handle remainder => sub {
	my @args = split /\s+/;
	my $function = lc shift @args;
	return $help, html => $help_html if $function eq 'help' or $function eq 'h';
	
	my $sequence = uc join "", @args if @args;    # The rest of argument should be seq, even with whitespace mistakes
	return unless $sequence;                      # If no sequence, then quit and return nothing
	$sequence =~ s/[^$nucleotides$amino_acids]//; # Delete all non-amino_acid/non-nucleotide characters
	$sequence =~ tr/U/T/;                         # Make to DNA, for standardization, and since tu provides return to RNA
						      #  also, T is an amino acid, U isn't
	for ($sequence) {
		my $return_value = $functions{$function}->() if exists $functions{$function};
		my $return_value_html = $return_value;
		$return_value_html =~ s/\n/<br>/g if $return_value_html;
		return $return_value, html => $return_value_html;
	}
};

1;
