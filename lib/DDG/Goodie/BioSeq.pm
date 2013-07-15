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
attribution email => 'chreod@lavabit.com';

my $help = "To use the \"bioseq\" DDGoodie, enter a function name then the nucleotide or amino acid sequence."
         . "\n	r	reverse the sequence, return DNA"
         . "\n	c	complement the sequence, return DNA"
         . "\n	rc	reverse-complement the sequence, return DNA"
         . "\n	tu	replace all T with U"
         . "\n	tln	translate nucleotides to amino acids in three frames"
         . "\n	t	estimate the melting temperature of sequence as DNA"
         . "\n	w	estimate the DNA weight of sequence as DNA"
         . "\nFor example, \"bioseq rc ATCGCGATUCGAT\" would return the reversed complementary sequence."
         . "\nFor example, \"bioseq tln ATCGCGATUCGAT\" would return the translation of the sequence.";

my $nucleotides = "ATCGU";
my $amino_acids = "FLSYCWPHQRIMTNKVADEG";

my %tln_table = (
    #Each amino acid is on a row, with codons that map to it
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

my %functions = (
    "reverse"            => sub { "Reversed: ".reverse },
    "r"                  => sub { "Reversed: ".reverse },
    "complement"         => sub { tr/ATCGU/TAGCA/; "Complement: $_" },
    "c"                  => sub { tr/ATCGU/TAGCA/; "Complement: $_" },
    "reverse-complement" => sub { tr/ATCGU/TAGCA/; "Reversed complement: ".reverse },
    "rc"                 => sub { tr/ATCGU/TAGCA/; "Reversed complement: ".reverse },
    "translate"          => sub { "Translated to amino acid sequence:".translate($_) },
    "tln"                => sub { "Translated to amino acid sequence:".translate($_) },
    "tu"                 => sub { tr/T/U/; "T's turned to U's: $_" },
    "temp"               => sub { "Estimated melting temperature of ".temp($_)." Celsius, supposing 50mM monovalent cations." },
    "t"                  => sub { "Estimated melting temperature of ".temp($_)." Celsius, supposing 50mM monovalent cations." },
    "weight"             => sub { "That sequence, as DNA without a 5' phosphate, would weigh ".weight($_)." grams per mole." },
    "w"                  => sub { "That sequence, as DNA without a 5' phosphate, would weigh ".weight($_)." grams per mole." },
);

sub translate {
    return "[ERROR: Non-nucleotide characters detected]" if $_[0] =~ /[^ATCGU]/;
    $_[0] =~ tr/T/U/; # Turn DNA to RNA
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
    my $report;
    foreach my $frame (0..$#frame) {
        # Give me the title and the translation string, if it exists
        $report .= "\n\n\tFrame ".($frame+1).": $tln[$frame]" if $tln[$frame];
    }
    return $report;
}
	

sub temp {
    return "[ERROR: Non-nucleotide characters detected]" if $_[0] =~ /[^ATCGU]/;
    my $gc_count = $_[0] =~ tr/CG/CG/;  #tr returns the number of transliterations it makes
    return (4 * $gc_count + 2 * ((scalar length $_[0]) - $gc_count)) if (scalar length $_[0]) < 14;
    # The above is for less than 14 length, below is for more than that
    return (64.9 + 41 * ($gc_count - 16.4) / scalar length $_[0]);
    # This formula is as cited in Promega's biomath page
    # http://www.promega.com/techserv/tools/biomath/calc11.htm
}

sub weight {
    return "[ERROR: Non-nucleotide characters detected]" if $_[0] =~ /[^ATCGU]/;
    my $g = $_[0] =~ tr/G/G/;  # Count each one individually
    my $c = $_[0] =~ tr/C/C/;
    my $a = $_[0] =~ tr/A/A/;
    my $t = $_[0] =~ tr/TU/TU/;  # Both count as T
    return ((329.2 * $g) + (313.2 * $a) + (304.2 * $t) + (289.2 * $c));
    # This formula is as cited in Promega's biomath page
    # http://www.promega.com/techserv/tools/biomath/calc11.htm
}

handle remainder => sub {
	my @args = split /\s+/;
	my $function = lc shift @args;
    return $help if $function eq 'help' or $function eq 'h';
	
	my $sequence = uc join "", @args if @args;    # The rest of argument should be seq, even with whitespace errors
	return unless $sequence;                      # If no sequence, then quit and return nothing
	$sequence =~ s/[^$nucleotides$amino_acids]//; # Delete all non-amino_acid/non-nucleotide characters
	$sequence =~ tr/U/T/;                         # Make to DNA, for standardization, and since tu provides return to RNA
							                      # also, T is an amino acid, U isn't
    for ($sequence) {
        return $functions{$function}->()
            if exists $functions{$function};
    }
};

1;
