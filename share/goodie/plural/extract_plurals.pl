#!/usr/bin/perl

use Modern::Perl 2014;
use autodie;
use utf8;
$|++;

my $unsanitary = qr/[^\p{L}\s\-']/;

my $dictionaryFile = 'enwiktionary-20140522-pages-articles.xml';
open DICT, "<:utf8", $dictionaryFile;

my %terms;
my $term;
my $ns;
my $is_English;
my $is_noun;

say "Processing wiktionary...";

#It's not worth parsing the XML 'properly' as the actual page
# contents are just flat text (with wiki markup)
while (<DICT>) {

  print "\r$. lines processed" unless $. % 10000;

  #A new term begins
  if (/<title>(?<term>.+)<\/title>/) {

    $term = $+{term};

    #Suppress storing anything until we know it's
    # a dictionary entry and an English noun
    $ns = 1;
    $is_English = 0;
    $is_noun = 0;

  }

  #Non-entry pages e.g. Help pages have non-zero ns
  if (/<ns>(?<ns>\d+)<\/ns>/) {
    $ns = $+{ns};
  }
  next if $ns;

  #Ensure the term is English
  $is_English++ if /=English=/;
  next unless $is_English;
  
  #Ensure the term is a noun
  $is_noun++ if /=Noun=/;
  next unless $is_noun;

  #Don't want weirdness
  next if $term =~ /$unsanitary/;

  #Skip acronyms and intialisms
  next if $term =~ /^[^a-z]{2,}$/;

  #All terms are stored in lower case, and 
  # matched case-insensitively. This is a tradeoff
  # between allowing for users' idiosyncracies in 
  # capitalisation (e.g. 'What Is The Plural Of Starfish')
  # and the edge case where two different case-forms
  # of the same word (e.g. 'Zulu' and 'zulu') have 
  # different correct plural forms (this is extremely
  # unlikely, I couldn't actually find any real examples).
  # However, even in this edge case it will still return
  # all the possible correct pluralisations.
  my $termKey = lc($term);

  #Parse the Template:en-noun to grab the plural
  # Reference: https://en.wiktionary.org/wiki/Template:en-noun
  if (/{{en-noun(\|(?<plurals>[^\}]+))?}}/) {

    #If no plural form information is given,
    # the plural form is '-s'
    if (! $+{plurals}) {
      $terms{$termKey}{$term . 's'}++;
      next; 
    }

    my @forms = split(/\|/, $+{plurals});

    foreach my $form (@forms) {

      #Hyphen indicates uncountable or usually uncountable,
      # meaningless for our purposes
      if ($form eq '-') {
        next; 

      #Tilde indicates countable and uncountable, with -s
      # pluralisation unless an alternative is specified
      } elsif ($form eq '~') {
        $terms{$termKey}{$term . 's'}++ if @forms == 1;

      #Exclamation point indicates an unattested plural,
      # question mark indicates uncertain or unknown;
      # ignore these for now
      } elsif ($form eq '!' || $form eq '?') {
        next;

      #'s' and 'es' indicate standard -s or -es forms
      } elsif ($form eq 's' || $form eq 'es') {
        warn('Form ' . $form . ' looks unsanitary') if $form =~ /$unsanitary/;
        next if $form =~ /$unsanitary/;
        $terms{$termKey}{$term . $form}++;

      #Markup in square brackets is used for multi-word
      # terms, with -s pluralisation unless an alternative
      # is specified
      } elsif ($form =~ /\[|\]/) {
        $terms{$termKey}{$term . 's'}++ if @forms == 1;
      
      #Anything else is an explicit specification of a
      # plural form, usuall irregular
      } else {
        next if $form =~ /$unsanitary/;
        $terms{$termKey}{$form}++;
      }
    }
  }
}
say "\r$. lines processed";
close DICT;

say "Writing plurals.txt...";
open PLURALS, ">:utf8", "plurals.txt";
foreach my $term (sort keys(%terms)) {

  next unless $terms{$term};
  say PLURALS $term . "\t" . join("\t", keys %{$terms{$term}});

}
close PLURALS;
say "Done";
