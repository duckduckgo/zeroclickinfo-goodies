#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'reverse_complement';
zci is_cached   => 1;

my @aaaacccggt = (
    "ACCGGGTTTT",
    structured_answer => {
        input     => ['AAAACCCGGT'],
        operation => 'Nucleotide reverse complement',
        result    => 'ACCGGGTTTT'
    });

ddg_goodie_test(
    [qw( DDG::Goodie::ReverseComplement)],

    #Basic DNA reverse complements, various trigger combinations
    'AAAACCCGGT reverse complement'                            => test_zci(@aaaacccggt),
    'reverse complement of TTTGATCATGGCTCAGGACGAACGCTGGCGGCGT' => test_zci(
        "ACGCCGCCAGCGTTCGTCCTGAGCCATGATCAAA",
        structured_answer => {
            input     => ['TTTGATCATGGCTCAGGACGAACGCTGGCGGCGT'],
            operation => 'Nucleotide reverse complement',
            result    => 'ACGCCGCCAGCGTTCGTCCTGAGCCATGATCAAA'
        }
    ),
    'AAAACCCGGT revcomp'                            => test_zci(@aaaacccggt),
    'revcomp AAAACCCGGT'                            => test_zci(@aaaacccggt),
    'revcomp of AAAACCCGGT'                         => test_zci(@aaaacccggt),
    'DNA revcomp of sequence AAAACCCGGT'            => test_zci(@aaaacccggt),
    'reverse complement of RNA sequence AAAACCCGGU' => test_zci(
        "ACCGGGTTTT",
        structured_answer => {
            input     => ['AAAACCCGGU'],
            operation => 'Nucleotide reverse complement',
            result    => 'ACCGGGTTTT'
        }
    ),

    #RNA reverse complement with acceptable spacing characters
    'reverse complement uca gac gga' => test_zci(
        "TCCGTCTGA",
        structured_answer => {
            input     => ['UCAGACGGA'],
            operation => 'Nucleotide reverse complement',
            result    => 'TCCGTCTGA',
        }
    ),
    'reverse complement of nucleotide sequence uca-gac-gga' => test_zci(
        "TCCGTCTGA",
        structured_answer => {
            input     => ['UCAGACGGA'],
            operation => 'Nucleotide reverse complement',
            result    => 'TCCGTCTGA',
        }
    ),

    #With ambiguous bases (both DNA and RNA)
    'reverse complement TCAAAWWDGGATTAMATACCCTGGTAGTCCACRCCATAAACGATGTATGCTTGGTGRGVGTGAGTAATCACTCAGTMCGAAGGCAACCTGATAAGCATACCKCCTVGAGTACGATCSCAAGGTTGAAACTCA DNA sequence'
      => test_zci(
        "TGAGTTTCAACCTTGSGATCGTACTCBAGGMGGTATGCTTATCAGGTTGCCTTCGKACTGAGTGATTACTCACBCYCACCAAGCATACATCGTTTATGGYGTGGACTACCAGGGTATKTAATCCHWWTTTGA",
        structured_answer => {
            input => [
                'TCAAAWWDGGATTAMATACCCTGGTAGTCCACRCCATAAACGATGTATGCTTGGTGRGVGTGAGTAATCACTCAGTMCGAAGGCAACCTGATAAGCATACCKCCTVGAGTACGATCSCAAGGTTGAAACTCA'
            ],
            operation => 'Nucleotide reverse complement',
            result =>
              'TGAGTTTCAACCTTGSGATCGTACTCBAGGMGGTATGCTTATCAGGTTGCCTTCGKACTGAGTGATTACTCACBCYCACCAAGCATACATCGTTTATGGYGTGGACTACCAGGGTATKTAATCCHWWTTTGA'
        },
      ),
    'reverse complement CUAKCCAAGCCGACGASUCGGUAGCUGGUCUGAGAGKGACGAACAGCCACACUGGAACUGAGACAYCGGUCCAGACUCCUACGGGAGGCAGCAGUGAGGAAUAUUGGUCAAKUGGACRGCAAGUCUGAACCAYGCGACGRCGCGUGCGGGAUGAAGGGGCUUAGCCUCGUAAACDCGCURGUCAAGAGGGACGAGAGGHGCGAUUUUGUMCGUCCGGGWWACGV'
      => test_zci(
        "BCGTWWCCCGGACGKACAAAATCGCDCCTCTCGTCCCTCTTGACYAGCGHGTTTACGAGGCTAAGCCCCTTCATCCCGCACGCGYCGTCGCRTGGTTCAGACTTGCYGTCCAMTTGACCAATATTCCTCACTGCTGCCTCCCGTAGGAGTCTGGACCGRTGTCTCAGTTCCAGTGTGGCTGTTCGTCMCTCTCAGACCAGCTACCGASTCGTCGGCTTGGMTAG",
        structured_answer => {
            input => [
                'CUAKCCAAGCCGACGASUCGGUAGCUGGUCUGAGAGKGACGAACAGCCACACUGGAACUGAGACAYCGGUCCAGACUCCUACGGGAGGCAGCAGUGAGGAAUAUUGGUCAAKUGGACRGCAAGUCUGAACCAYGCGACGRCGCGUGCGGGAUGAAGGGGCUUAGCCUCGUAAACDCGCURGUCAAGAGGGACGAGAGGHGCGAUUUUGUMCGUCCGGGWWACGV'
            ],
            operation => 'Nucleotide reverse complement',
            result =>
              'BCGTWWCCCGGACGKACAAAATCGCDCCTCTCGTCCCTCTTGACYAGCGHGTTTACGAGGCTAAGCCCCTTCATCCCGCACGCGYCGTCGCRTGGTTCAGACTTGCYGTCCAMTTGACCAATATTCCTCACTGCTGCCTCCCGTAGGAGTCTGGACCGRTGTCTCAGTTCCAGTGTGGCTGTTCGTCMCTCTCAGACCAGCTACCGASTCGTCGGCTTGGMTAG'
        },
      ),

    #Mix of DNA and RNA bases (should return empty, as it is more likely that this
    # is an error than one of the edge cases of uracil-containing DNA)
    'reverse complement AAATTTCCCGGGUUU' => undef,

    #Non-nucleic acid query strings (should return empty, no idea what they wanted)
    'reverse complement hello-this-is-DNA' => undef,
    'DNA reverse complement'               => undef,

);

done_testing;

