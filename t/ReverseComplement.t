#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'reversecomplement';
zci is_cached => 0;

ddg_goodie_test(
	[qw(
		DDG::Goodie::ReverseComplement
	)],

  #Basic DNA reverse complements, all possible trigger combinations
	'reverse complement AAAACCCGGT' => test_zci("DNA reverse complement:\nACCGGGTTTT"),
	'reverse complement of TTTGATCATGGCTCAGGACGAACGCTGGCGGCGT' => test_zci("DNA reverse complement:\nACGCCGCCAGCGTTCGTCCTGAGCCATGATCAAA"),
	'revcomp AAAACCCGGT' => test_zci("DNA reverse complement:\nACCGGGTTTT"),
	'revcomp of AAAACCCGGT' => test_zci("DNA reverse complement:\nACCGGGTTTT"),

  #RNA reverse complement with acceptable spacing characters
	'reverse complement uca gac gga' => test_zci("DNA reverse complement:\nTCCGTCTGA"),
	'reverse complement uca-gac-gga' => test_zci("DNA reverse complement:\nTCCGTCTGA"),

  #With ambiguous bases (both DNA and RNA)
	'reverse complement TCAAAWWDGGATTAMATACCCTGGTAGTCCACRCCATAAACGATGTATGCTTGGTGRGVGTGAGTAATCACTCAGTMCGAAGGCAACCTGATAAGCATACCKCCTVGAGTACGATCSCAAGGTTGAAACTCA' => test_zci("DNA reverse complement:\nTGAGTTTCAACCTTGSGATCGTACTCBAGGMGGTATGCTTATCAGGTTGCCTTCGKACTGAGTGATTACTCACBCYCACCAAGCATACATCGTTTATGGYGTGGACTACCAGGGTATKTAATCCHWWTTTGA"),
	'reverse complement CUAKCCAAGCCGACGASUCGGUAGCUGGUCUGAGAGKGACGAACAGCCACACUGGAACUGAGACAYCGGUCCAGACUCCUACGGGAGGCAGCAGUGAGGAAUAUUGGUCAAKUGGACRGCAAGUCUGAACCAYGCGACGRCGCGUGCGGGAUGAAGGGGCUUAGCCUCGUAAACDCGCURGUCAAGAGGGACGAGAGGHGCGAUUUUGUMCGUCCGGGWWACGV' => test_zci("DNA reverse complement:\nBCGTWWCCCGGACGKACAAAATCGCDCCTCTCGTCCCTCTTGACYAGCGHGTTTACGAGGCTAAGCCCCTTCATCCCGCACGCGYCGTCGCRTGGTTCAGACTTGCYGTCCAMTTGACCAATATTCCTCACTGCTGCCTCCCGTAGGAGTCTGGACCGRTGTCTCAGTTCCAGTGTGGCTGTTCGTCMCTCTCAGACCAGCTACCGASTCGTCGGCTTGGMTAG"),

  #Mix of DNA and RNA bases (should return empty, as it is more likely that this
  # is an error than one of the edge cases of uracil-containing DNA)
	'reverse complement AAATTTCCCGGGUUU' => undef,
  
  #Non-nucleic acid query string (should return empty, no idea what they wanted)
	'reverse complement hello-this-is-DNA' => undef,

);

done_testing;

