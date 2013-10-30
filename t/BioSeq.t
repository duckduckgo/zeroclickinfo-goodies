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
	#1
	$dtest			=> test_zci('Recognized DNA sequence GATACA...
Reversed: ACATAG
Complement: CTATGT
Reverse Complement: TGTATC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1818.25 grams per mole
Estimated melting temperature of 16.00 Celsius, supposing 50mM monovalent cations
',html =>'Recognized DNA sequence GATACA...<br>Reversed: ACATAG<br>Complement: CTATGT<br>Reverse Complement: TGTATC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1818.25 grams per mole<br>Estimated melting temperature of 16.00 Celsius, supposing 50mM monovalent cations<br><a href="http://www.promega.com/techserv/tools/biomath/calc11.htm">Temperature formula from Promega</a>'),
	#2
	'dna '.$dtest		=> test_zci('Recognized DNA sequence GATACA...
Reversed: ACATAG
Complement: CTATGT
Reverse Complement: TGTATC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1818.25 grams per mole
Estimated melting temperature of 16.00 Celsius, supposing 50mM monovalent cations
',html =>'Recognized DNA sequence GATACA...<br>Reversed: ACATAG<br>Complement: CTATGT<br>Reverse Complement: TGTATC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1818.25 grams per mole<br>Estimated melting temperature of 16.00 Celsius, supposing 50mM monovalent cations<br><a href="http://www.promega.com/techserv/tools/biomath/calc11.htm">Temperature formula from Promega</a>'),
	#3
	'rna '.$dtest		=> test_zci('Recognized RNA sequence GAUACA...
Reversed: ACAUAG
Complement: CUAUGU
Reverse Complement: UGUAUC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1791.21 grams per mole
',html =>'Recognized RNA sequence GAUACA...<br>Reversed: ACAUAG<br>Complement: CUAUGU<br>Reverse Complement: UGUAUC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1791.21 grams per mole<br>'),
	#4
	'protein '.$dtest	=> test_zci('Recognized Amino Acid sequence GATACA...
That amino acid sequence weighs about 492.55 dalton
',html =>'Recognized Amino Acid sequence GATACA...<br>That amino acid sequence weighs about 492.55 dalton<br>'),
	#5
	$rtest			=> test_zci('Recognized RNA sequence GAUAUA...
Reversed: AUAUAG
Complement: CUAUAU
Reverse Complement: UAUAUC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1806.22 grams per mole
',html => 'Recognized RNA sequence GAUAUA...<br>Reversed: AUAUAG<br>Complement: CUAUAU<br>Reverse Complement: UAUAUC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1806.22 grams per mole<br>'),
	#6
	'dNa '.$rtest		=> test_zci('Recognized DNA sequence GATATA...
Reversed: ATATAG
Complement: CTATAT
Reverse Complement: TATATC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1833.27 grams per mole
Estimated melting temperature of 14.00 Celsius, supposing 50mM monovalent cations
',html => 'Recognized DNA sequence GATATA...<br>Reversed: ATATAG<br>Complement: CTATAT<br>Reverse Complement: TATATC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1833.27 grams per mole<br>Estimated melting temperature of 14.00 Celsius, supposing 50mM monovalent cations<br><a href="http://www.promega.com/techserv/tools/biomath/calc11.htm">Temperature formula from Promega</a>'),
	#7
	'rnA '.$rtest		=> test_zci('Recognized RNA sequence GAUAUA...
Reversed: AUAUAG
Complement: CUAUAU
Reverse Complement: UAUAUC
That 5\' unphosphorylated single stranded DNA sequence weighs about 1806.22 grams per mole
',html => 'Recognized RNA sequence GAUAUA...<br>Reversed: AUAUAG<br>Complement: CUAUAU<br>Reverse Complement: UAUAUC<br>That 5\' unphosphorylated single stranded DNA sequence weighs about 1806.22 grams per mole<br>'),
	#8
	'amino acid '.$rtest	=> test_zci('Recognized Amino Acid sequence GAUAUA...
That amino acid sequence weighs about 588.38 dalton
',html => 'Recognized Amino Acid sequence GAUAUA...<br>That amino acid sequence weighs about 588.38 dalton<br>'),
	#9
	$ptest			=> test_zci('Recognized Amino Acid sequence MSNTSSYEKNNPDN...
That amino acid sequence weighs about 1600.63 dalton
',html => 'Recognized Amino Acid sequence MSNTSSYEKNNPDN...<br>That amino acid sequence weighs about 1600.63 dalton<br>'),
	#10
	'aminoacid '.$ptest	=> test_zci('Recognized Amino Acid sequence MSNTSSYEKNNPDN...
That amino acid sequence weighs about 1600.63 dalton
',html => 'Recognized Amino Acid sequence MSNTSSYEKNNPDN...<br>That amino acid sequence weighs about 1600.63 dalton<br>'),
	#11
	#'dna '.$ptest		=> test_zci(undef),
	#12
	#'rna '.$ptest		=> test_zci('',html => ''),
	#13
	#$long_seq		=> test_zci('',html => ''),
	#14
	#$long_seq.' dna'	=> test_zci('',html => ''),
	#15
	#$long_seq.' rna'	=> test_zci('',html => ''),
	#16
	#$long_seq.' protein'	=> test_zci('',html => ''),
);

done_testing;
