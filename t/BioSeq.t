#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'bioseq';

my $long_seq = "TTTATAAGAAACAAAAAAAAGAAAUAAAAAATGAGTAATACTTCUUCGTACGAGAAGAATAATCCAGATAATCTGAAACACAAUGGTATTACCATAGATTCTGAGTUUCTAACtcaggaGCCAATAACCATTCCCTCAAATGGCTCCGCTGTTTCTATTGACGAAACAGGTTCAGGGTCCAAATGGCAAGACTTTAAAGATTCTTTCAAAAGGGTAAAACCTATTGAAGTTGATCCTAATCTTTCAGAAGCTGAAAAAGTGGCTATCATCACTGCCCAAACTCCATTGAAGCACCACTTGAAGAATAGACATTTGCAAATGATTGCCATCGGTGGTGCCATCGGTACTGGTCTGCTGGTTGGGTCAGGTACTGCACTAAGAACAGGTGGTCCCGCTTCGCTACTGATTGGATGGGGGTC";
#"TTTATAAGAAACAAAAAAAAGAAAtAAAAAATGAGTAATACTTCtTCGTACGAGAAGAATAATCCAGATAATCTGAAACACAATGGTATTACCATAGATTCTGAGTttCTAACtcaggaGCCAATAACCATTCCCTCAAATGGCTCCGCTGTTTCTATTGACGAAACAGGTTCAGGGTCCAAATGGCAAGACTTTAAAGATTCTTTCAAAAGGGTAAAACCTATTGAAGTTGATCCTAATCTTTCAGAAGCTGAAAAAGTGGCTATCATCACTGCCCAAACTCCATTGAAGCACCACTTGAAGAATAGACATTTGCAAATGATTGCCATCGGTGGTGCCATCGGTACTGGTCTGCTGGTTGGGTCAGGTACTGCACTAAGAACAGGTGGTCCCGCTTCGCTACTGATTGGATGGGGGTC";
#GAP1 from -30 to +190, with some T's -> U's from yeastgenome.org
my $test_pseq = 
my $dtest = "gAtAca";
my $rtest = "gAuaUa";
my $ptest = "MSNTSsyeknNPDN";

ddg_goodie_test(
	['DDG::Goodie::BioSeq'],
	$dtest			=> test_zci('Recognized DNA sequence...
Reversed: ACATAG
Complement: CTATGT
Reverse Complement: TGTATC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1818.25 grams per mole
Estimated melting temperature of 16.00 Celsius, supposing 50mM monovalent cations
',html =>'Recognized DNA sequence...<br>Reversed: ACATAG<br>Complement: CTATGT<br>Reverse Complement: TGTATC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1818.25 grams per mole<br>Estimated melting temperature of 16.00 Celsius, supposing 50mM monovalent cations<br><a href="http://www.promega.com/techserv/tools/biomath/calc11.htm">Temperature formula from Promega</a>'),
	'dna '.$dtest		=> test_zci('Recognized DNA sequence...
Reversed: ACATAG
Complement: CTATGT
Reverse Complement: TGTATC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1818.25 grams per mole
Estimated melting temperature of 16.00 Celsius, supposing 50mM monovalent cations
',html =>'Recognized DNA sequence...<br>Reversed: ACATAG<br>Complement: CTATGT<br>Reverse Complement: TGTATC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1818.25 grams per mole<br>Estimated melting temperature of 16.00 Celsius, supposing 50mM monovalent cations<br><a href="http://www.promega.com/techserv/tools/biomath/calc11.htm">Temperature formula from Promega</a>'),
	'rna '.$dtest		=> test_zci('Recognized RNA sequence...
Reversed: ACAUAG
Complement: CUAUGU
Reverse Complement: UGUAUC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1791.21 grams per mole
',html =>'Recognized RNA sequence...<br>Reversed: ACAUAG<br>Complement: CUAUGU<br>Reverse Complement: UGUAUC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1791.21 grams per mole<br>'),
	'protein '.$dtest	=> test_zci('Recognized Amino Acid sequence...
That amino acid sequence weighs about 966.11 dalton
',html =>'Recognized Amino Acid sequence...<br>That amino acid sequence weighs about 966.11 dalton<br>'),
	$rtest			=> test_zci('Recognized RNA sequence...
Reversed: AUAUAG
Complement: CUAUAU
Reverse Complement: UAUAUC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1806.22 grams per mole
',html => 'Recognized RNA sequence...<br>Reversed: AUAUAG<br>Complement: CUAUAU<br>Reverse Complement: UAUAUC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1806.22 grams per mole<br>'),
	'dNa '.$rtest		=> test_zci('Recognized DNA sequence...
Reversed: ATATAG
Complement: CTATAT
Reverse Complement: TATATC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1833.27 grams per mole
Estimated melting temperature of 14.00 Celsius, supposing 50mM monovalent cations
',html => 'Recognized DNA sequence...<br>Reversed: ATATAG<br>Complement: CTATAT<br>Reverse Complement: TATATC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1833.27 grams per mole<br>Estimated melting temperature of 14.00 Celsius, supposing 50mM monovalent cations<br><a href="http://www.promega.com/techserv/tools/biomath/calc11.htm">Temperature formula from Promega</a>'),
	'rnA '.$rtest		=> test_zci('Recognized RNA sequence...
Reversed: AUAUAG
Complement: CUAUAU
Reverse Complement: UAUAUC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1806.22 grams per mole
',html => 'Recognized RNA sequence...<br>Reversed: AUAUAG<br>Complement: CUAUAU<br>Reverse Complement: UAUAUC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1806.22 grams per mole<br>'),
	'amino acid '.$rtest	=> test_zci('Recognized Amino Acid sequence...
That 5\' triphosphorylated single stranded RNA sequence weighs about 2123.12 grams per mole
',html => 'Recognized Amino Acid sequence...<br>That 5\' triphosphorylated single stranded RNA sequence weighs about 2123.12 grams per mole<br>'),
	$ptest			=> test_zci('Recognized Amino Acid sequence...
That amino acid sequence weighs about 1600.63 dalton
',html => 'Recognized Amino Acid sequence...<br>That amino acid sequence weighs about 1600.63 dalton<br>'),
	#'dna '.$ptest		=> test_zci(undef),
	#'rna '.$ptest		=> test_zci('',html => ''),
	'aminoacid '.$ptest	=> test_zci('Recognized Amino Acid sequence...
That amino acid sequence weighs about 1087.32 dalton
',html => 'Recognized Amino Acid sequence...<br>That amino acid sequence weighs about 1087.32 dalton<br>'),
	#~ $long_seq		=> test_zci('',html => ''),
	#~ $long_seq.' dna'	=> test_zci('',html => ''),
	#~ $long_seq.' rna'	=> test_zci('',html => ''),
	#~ $long_seq.' protein'	=> test_zci('',html => ''),
);

done_testing;
