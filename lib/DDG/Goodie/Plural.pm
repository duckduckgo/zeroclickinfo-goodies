package DDG::Goodie::Plural;
# ABSTRACT: Pluralise English nouns

use DDG::Goodie;
use Lingua::EN::Inflect qw(WORDLIST);
use JSON::XS qw(decode_json);
use File::Slurp qw(read_file);
use feature 'state';
use URI::Escape qw(uri_escape_utf8);

primary_example_queries 'pluralise starfish';
secondary_example_queries 'pluralize fungus', 'what is the plural form of cul-de-sac', 'how do you pluralise radius', 'what is the correct pluralization of medium', 'pluralise the word plethora', 'plural inflection of bacterium';
description 'Pluralise an English noun';
name 'Plural';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Plural.pm';
category 'transformations';
topics 'words_and_games';

attribution github => ['https://github.com/wilkox', 'wilkox'];

triggers any => 'plural', 'pluralise', 'pluralize', 'pluralisation', 'pluralization';

zci is_cached => 1;

#Load Wiktionary plurals
our %plurals = %{decode_json(read_file(share('plurals.json')->stringify))};

handle remainder => sub {

  my $term = $_;
  $term =~ s/\t/ /g;

  #It's far more likely someone would be looking for a 
  # wikipedia article than the plural of 'wikipedia'
  return if $term =~ /\bwikipedia\b/;

  #Clean up the query
  $term =~ s/^(what\sis\s|what\sare\s|what'?s\s)the\s(correct\s)?//i;
  $term =~ s/^how\s(do\syou\s|to\s)(correctly\s)?//i;
  $term =~ s/the\s(english\s)?(word|term)\s//i;
  $term =~ s/(forms?\s)?(inflections?\s)?of\s//i;

  #Check that the term is in Wiktionary
  return unless exists $plurals{lc($term)};

  #Get the plural forms
  my @pluralForms = keys %{$plurals{lc($term)}};
  
  return WORDLIST(@pluralForms, {conj => 'or'}), 
         html => wrap_html($term, @pluralForms);
  return;
};

sub wrap_html {

  state $css = share('style.css')->slurp;
  my $html = "<style type='text/css'>$css</style>";

  (my $term, my @pluralForms) = @_;

  @pluralForms = map { "<span class='plural'><a href='" . wiktionary_URL($_) . "'>" . $_ . "</a></span>" } @pluralForms;

  #Convert to a natual English list
  my $natural = WORDLIST(@pluralForms, {conj => "<span class='label'>or</span>"});

  $html .= "<div class='zci--plural'>";
  $html .= "<span class='label'>The plural of $term is</span> $natural";
  $html .= "<span class='label'> (did you mean</span> <a href=\"http://en.wikipedia.org/wiki/Pleural_fluid#Pleural_fluid\">pleural fluid</a><span class='label'>)?</span>" if $term eq "fluid";
  $html .= "<div class='source'><a href='" . wiktionary_URL($term) ."'>More at Wiktionary</a></div>";
  $html .= "</div>";

  return $html;

}

sub wiktionary_URL {

  my $term = shift;
  $term = uri_escape_utf8($term);
  return 'https://en.wiktionary.org/wiki/' . $term;

}

1;
