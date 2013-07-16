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
    #Stop codon is X
    #Need to add attribution for the codon table to IUPAC website
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
my %amino_acid_weight = (
	#I know the three significant figures are ridiculous, but that was how I found the values:
	#http://web.expasy.org/protscale/pscale/Molecularweight.html
	#These weights are off...
	"A"	=>	89.000,
	"R"	=>	174.000,
	"N"	=>	132.000,
	"D"	=>	133.000,
	"C"	=>	121.000,
	"Q"	=>	146.000,
	"E"	=>	147.000,
	"G"	=>	75.000,
	"H"	=>	155.000,
	"I"	=>	131.000,
	"L"	=>	131.000,
	"K"	=>	146.000,
	"M"	=>	149.000,
	"F"	=>	165.000,
	"P"	=>	115.000,
	"S"	=>	105.000,
	"T"	=>	119.000,
	"W"	=>	204.000,
	"Y"	=>	181.000,
	"V"	=>	117.000
);
my %nucleotide_weight = (
	"A"	=>	313.2,
	"T"	=>	304.2,
	#"U"	=>	?????,	#Look up later for dUTP applications
	"G"	=>	329.2,
	"C"	=>	289.2
);
my $amino_acids = join("", values(%tln_table));	# aka "FLSYCWPHQRIMTNKVADEG"
$amino_acids =~ s/X//g;	#Two steps so that if we use a non-canonical table above, we can still get our string of possible nucleotides
my $nucleotides = "ATCGU";

my %functions = (
    "reverse"            => sub { "Reversed: ".reverse },
    "r"                  => sub { "Reversed: ".reverse },
    "complement"         => sub { tr/ATCGU/TAGCA/; "Complement: $_" },
    "c"                  => sub { tr/ATCGU/TAGCA/; "Complement: $_" },
    "reverse-complement" => sub { tr/ATCGU/TAGCA/; "Reversed complement: ".reverse },
    "rc"                 => sub { tr/ATCGU/TAGCA/; "Reversed complement: ".reverse },
    "tu"                 => sub { tr/T/U/; "T's turned to U's: $_" },
    "translate"          => sub { translate($_) },
    "tln"                => sub { translate($_) },    
    "temp"               => sub { temp($_) },
    "t"                  => sub { temp($_) },
    "weight"             => sub { weight($_) },
    "w"                  => sub { weight($_) },
);

sub translate {
    return "BioSeq Error: Can't translate non-nucleotide characters" if $_[0] =~ /[^ATCGU]/;
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
            if ($tln_table{$1} eq "X") {                 # If stop indicated
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
	$temperature .= " Celsius, supposing 50mM monovalent cations.";
	return $temperature;
	# This formula is as cited in Promega's biomath page
	# http://www.promega.com/techserv/tools/biomath/calc11.htm
}

sub weight {
	my $weighing_seq = $_[0];
	my $weight = 0;
	if ($weighing_seq =~ /[^ATCGU]/) {
		#If it has non-nucleotides, it must be a protein, so use a different table
		foreach (split(//, $weighing_seq)) {
			$weight += $amino_acid_weight{$_};
		}
		$weight = "That amino acid sequence weighs about ".$weight;
		$weight	.= " dalton";
	} else {
		foreach (split(//, $weighing_seq)) {
			$weight += $nucleotide_weight{$_};
		}
		$weight = "That amino acid sequence weighs about ".$weight;
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
		$return_value_html =~ s/\n/<br>/g;
		return $return_value, html => $return_value_html;
	}
};

1;
