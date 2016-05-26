#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'reverse_complement';
zci is_cached   => 1;

my @aaaacccggt = ("ACCGGGTTTT",'AAAACCCGGT');

sub build_test {
    my ($answer, $input) = @_;
    return test_zci($answer, structured_answer => {
        data => {
            title => $answer,
            subtitle => "Nucleotide reverse complement: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::ReverseComplement)],

    #Basic DNA reverse complements, various trigger combinations
    'AAAACCCGGT reverse complement'                 => build_test(@aaaacccggt),
    'AAAACCCGGT revcomp'                            => build_test(@aaaacccggt),
    'revcomp AAAACCCGGT'                            => build_test(@aaaacccggt),
    'revcomp of AAAACCCGGT'                         => build_test(@aaaacccggt),
    'DNA revcomp of sequence AAAACCCGGT'            => build_test(@aaaacccggt),
    'reverse complement of RNA sequence AAAACCCGGU' => build_test("ACCGGGTTTT", 'AAAACCCGGU'),
    'reverse complement of TTTGATCATGGCTCAGGACGAACGCTGGCGGCGT' => build_test("ACGCCGCCAGCGTTCGTCCTGAGCCATGATCAAA", 'TTTGATCATGGCTCAGGACGAACGCTGGCGGCGT'),

    #RNA reverse complement with acceptable spacing characters
    'reverse complement uca gac gga' => build_test("TCCGTCTGA", 'UCAGACGGA'),
    'reverse complement of nucleotide sequence uca-gac-gga' => build_test("TCCGTCTGA", 'UCAGACGGA'),

    #With ambiguous bases (both DNA and RNA)
    'reverse complement TCAAAWWDGGATTAMATACCCTGGTAGTCCACRCCATAAACGATGTATGCTTGGTGRGVGTGAGTAATCACTCAGTMCGAAGGCAACCTGATAAGCATACCKCCTVGAGTACGATCSCAAGGTTGAAACTCA DNA sequence'
        => build_test(
            "TGAGTTTCAACCTTGSGATCGTACTCBAGGMGGTATGCTTATCAGGTTGCCTTCGKACTGAGTGATTACTCACBCYCACCAAGCATACATCGTTTATGGYGTGGACTACCAGGGTATKTAATCCHWWTTTGA",
            'TCAAAWWDGGATTAMATACCCTGGTAGTCCACRCCATAAACGATGTATGCTTGGTGRGVGTGAGTAATCACTCAGTMCGAAGGCAACCTGATAAGCATACCKCCTVGAGTACGATCSCAAGGTTGAAACTCA'
    ),
    'reverse complement CUAKCCAAGCCGACGASUCGGUAGCUGGUCUGAGAGKGACGAACAGCCACACUGGAACUGAGACAYCGGUCCAGACUCCUACGGGAGGCAGCAGUGAGGAAUAUUGGUCAAKUGGACRGCAAGUCUGAACCAYGCGACGRCGCGUGCGGGAUGAAGGGGCUUAGCCUCGUAAACDCGCURGUCAAGAGGGACGAGAGGHGCGAUUUUGUMCGUCCGGGWWACGV'
        => build_test(
            "BCGTWWCCCGGACGKACAAAATCGCDCCTCTCGTCCCTCTTGACYAGCGHGTTTACGAGGCTAAGCCCCTTCATCCCGCACGCGYCGTCGCRTGGTTCAGACTTGCYGTCCAMTTGACCAATATTCCTCACTGCTGCCTCCCGTAGGAGTCTGGACCGRTGTCTCAGTTCCAGTGTGGCTGTTCGTCMCTCTCAGACCAGCTACCGASTCGTCGGCTTGGMTAG",
            'CUAKCCAAGCCGACGASUCGGUAGCUGGUCUGAGAGKGACGAACAGCCACACUGGAACUGAGACAYCGGUCCAGACUCCUACGGGAGGCAGCAGUGAGGAAUAUUGGUCAAKUGGACRGCAAGUCUGAACCAYGCGACGRCGCGUGCGGGAUGAAGGGGCUUAGCCUCGUAAACDCGCURGUCAAGAGGGACGAGAGGHGCGAUUUUGUMCGUCCGGGWWACGV',
      ),

    #Mix of DNA and RNA bases (should return empty, as it is more likely that this
    # is an error than one of the edge cases of uracil-containing DNA)
    'reverse complement AAATTTCCCGGGUUU' => undef,

    #Non-nucleic acid query strings (should return empty, no idea what they wanted)
    'reverse complement hello-this-is-DNA' => undef,
    'DNA reverse complement'               => undef,

);

done_testing;
