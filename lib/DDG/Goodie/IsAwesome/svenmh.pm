# Would like to change this to DDG::Goodie::PubMed, but I thought I'd see if
# DDG people like it or not first.
package DDG::Goodie::IsAwesome::svenmh;
# ABSTRACT: Provide links to PubMed articles

use DDG::Goodie;
use warnings;
use strict;
#use Data::Dumper;

use URI;
use LWP::Simple;

zci answer_type => "is_awesome_svenmh";
zci is_cached   => 1;

name "Get PubMed titles from https://www.ncbi.nlm.nih.gov/";
source "PubMed.gov";
description "Provide links to the PubMed database from PubMed IDs.";
primary_example_queries "pmid 17712414", "pmids 25428363 23203989";
#secondary_example_queries "optional -- demonstrate any additional triggers";
category "reference";
topics "science";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/svenmh.pm";
attribution github => ["https://github.com/svenmh", "Sven Heinicke"],
            twitter => "failedVegan";

triggers any => qw/pubmed pmid pmids/;

handle remainder => sub {
    return if !$_;

    # We only want numbers
    my @pmids=map{
        m/^\d+$/?$_:();
    }split(m/\s/,$_);

    return if 0==scalar(@pmids);
    my $pmids=join(' ',@pmids);

    # I'm sure there is a BioPerl way to get this, but for now...
    my $pubmed=URI->new('https://www.ncbi.nlm.nih.gov/pubmed/');
    my %qs=('report'=>'docsum','format'=>'text','term'=>$pmids);
    $pubmed->query_form(%qs);
    #warn $pubmed;
    
    # Guessing the DDS guys arn't going to like using LWP::Simple in a
    # goodie.
    my $got=get($pubmed);
    
    # we don't use a hash here as we want them in the order returned from pubmed.
    my @parced=docsum($got);

    # if we get zero quit.  Should check for odd number of elements and report
    # errors someplace.
    return if 2>scalar(@parced);

    my @out;
    my $count=0;
    while(@parced){
        my $pmid=shift(@parced);
        my $ref=shift(@parced);
   
        ++$count;
        $pubmed->query_form(['term'=>$pmid]);
        # As <ol> seems to be list-styled away, I'll number them the old fashoned way.
        push(@out,"<p>$count: <a href=\"$pubmed\">$ref</a></p>");
    }
    return $pmids,'html'=>join("\n",@out);
};

# Abstracted as I first was parsing MEDLINE entries before I remembered docsum.
sub docsum{
    my $lines=shift;
    $lines=~s/\<[^\>]*\>//g; # Strip @
    $lines=~s/^\s*//;
    $lines=~s/\s*$//;
    my @out=map{
        s/^\d+:\s*//;
        s/\s*$//;
        s/\s*\n\s*/ /g;
        if(m/PMID:\s+(\d+)./){
            $1=>$_;
        }else{
            ();
        }
    }split(m/\n{2,}/,$lines);
    return @out;
}

1;
