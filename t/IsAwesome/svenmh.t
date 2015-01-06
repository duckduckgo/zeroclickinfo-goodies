#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "is_awesome_svenmh";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::IsAwesome::svenmh )],
    
    # currently we only do numbers
    'pmid'=>undef,
    'pmid heinicke livstone'=>undef,
    
    # Hopefully well well never have this many PMIDs
    'pubmed 9999999999999999999999999'=>undef,
    
    # Test one PMID at a time
    'pmid 17712414'=>test_zci('17712414',
        'html'=>'<p>1: <a href="https://www.ncbi.nlm.nih.gov/pubmed/?term=17712414">Heinicke S, Livstone MS, Lu C, Oughtred R, Kang F, Angiuoli SV, White O, Botstein D, Dolinski K. The Princeton Protein Orthology Database (P-POD): a comparative genomics analysis tool for biologists. PLoS One. 2007 Aug 22;2(8):e766. PubMed PMID: 17712414; PubMed Central PMCID: PMC1942082.</a></p>'),
    
    # Try two PMIDs and some garbage
    'pmids 17712414 2468 flibblestone'=>test_zci('17712414 2468',
        'html'=>'<p>1: <a href="https://www.ncbi.nlm.nih.gov/pubmed/?term=17712414">Heinicke S, Livstone MS, Lu C, Oughtred R, Kang F, Angiuoli SV, White O, Botstein D, Dolinski K. The Princeton Protein Orthology Database (P-POD): a comparative genomics analysis tool for biologists. PLoS One. 2007 Aug 22;2(8):e766. PubMed PMID: 17712414; PubMed Central PMCID: PMC1942082.</a></p>'
                . "\n" .
                '<p>2: <a href="https://www.ncbi.nlm.nih.gov/pubmed/?term=2468">Ciarrocchi G, Fortunato A, Cobianchi F, Falaschi A. An intracellular endonuclease of Bacillus subtilis specific for single-stranded DNA. Eur J Biochem. 1976 Jan 15;61(2):487-92. PubMed PMID: 2468.</a></p>'),
);

done_testing;
