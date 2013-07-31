#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'bioseq';

my $long_seq = "TTTATAAGAAACAAAAAAAAGAAAUAAAAAATGAGTAATACTTCUUCGTACGAGAAGAATAATCCAGATAATCTGAAACACAAUGGTATTACCATAGATTCTGAGTUUCTAACtcaggaGCCAATAACCATTCCCTCAAATGGCTCCGCTGTTTCTATTGACGAAACAGGTTCAGGGTCCAAATGGCAAGACTTTAAAGATTCTTTCAAAAGGGTAAAACCTATTGAAGTTGATCCTAATCTTTCAGAAGCTGAAAAAGTGGCTATCATCACTGCCCAAACTCCATTGAAGCACCACTTGAAGAATAGACATTTGCAAATGATTGCCATCGGTGGTGCCATCGGTACTGGTCTGCTGGTTGGGTCAGGTACTGCACTAAGAACAGGTGGTCCCGCTTCGCTACTGATTGGATGGGGGTC";
#GAP1 from -30 to +190, with some T's -> U's from yeastgenome.org
my $test_pseq = 
my $dtest = "gAtAca";
my $rtest = "gAuaUa";
my $ptest = "MSNTSsyeknNPDN";

ddg_goodie_test(
	['DDG::Goodie::BioSeq'],
	$dtest			=> test_zci(,html => $help_html),
	'dna '.$dtest		=> test_zci(,html => $help_html),
	'rna '.$dtest		=> test_zci(,html => $help_html),
	'protein '.$dtest	=> test_zci(,html => $help_html),
	$rtest			=> test_zci(,html => $help_html),
	'dNa '.$rtest		=> test_zci(,html => $help_html),
	'rnA '.$rtest		=> test_zci(,html => $help_html),
	'amino acid '.$rtest	=> test_zci(,html => $help_html),
	$ptest			=> test_zci(,html => $help_html),
	'dna '.$ptest		=> test_zci(,html => $help_html),
	'rna '.$ptest		=> test_zci(,html => $help_html),
	'aminoacid '.$ptest	=> test_zci(,html => $help_html),
	$long_seq		=> test_zci(,html => $help_html),
	$long_seq.' dna'	=> test_zci(,html => $help_html),
	$long_seq.' rna'	=> test_zci(,html => $help_html),
	$long_seq.' protein'	=> test_zci(,html => $help_html),
);

done_testing;
