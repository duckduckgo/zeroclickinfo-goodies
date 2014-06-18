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
  my %pluralForms = %{$plurals{lc($term)}};
  
  return natural_list(nested_forms(%pluralForms)),
         html => wrap_html(lc($term), %pluralForms);
  return;
};

sub natural_list {

  my @items = @_;
  return WORDLIST(sort @items, {conj => "<span class='label'>or</span>"});

}

sub nested_forms {

  my %hash = @_;
  my @forms;
  foreach my $key (keys %hash) {
    push(@forms, $_) for keys %{$hash{$key}};
  }
  return sort @forms;

}

sub wrap_html {

  (my $lc, my %pluralForms) = @_;

  #Inject CSS and open div
  state $css = share('style.css')->slurp;
  my $html = "<style type='text/css'>$css</style>";
  $html .= "<div class='zci--plural'>";

  #For each matching caseform, construct a natural-language
  # statment of the plural forms with links to Wiktionary
  my @statements;
  foreach my $caseForm (sort keys %pluralForms) {
    my @pluralForms = map { "<span class='plural'><a href='" . wiktionary_URL($_) . "'>" . $_ . "</a></span>" } keys %{$pluralForms{$caseForm}};
    my $article = @statements == 0 ? 'The' : 'the';
    my $statement = "<span class='label'>$article plural of $caseForm is</span> " . natural_list(@pluralForms);
    push(@statements, $statement);
  }

  #Join the statements together and capitalise
  # the first word
  my $statement = join("<span class='label'>; </span>", @statements);
  $statement = ucfirst($statement);
  $html .= $statement;
  
  #Link back to Wiktionary and close off
  $html .= "<div class='source'><a href='" . wiktionary_URL($lc) ."'>More at Wiktionary</a></div>";
  $html .= "</div>";

  return $html;

}

sub wiktionary_URL {

  my $term = shift;
  $term = uri_escape_utf8($term);
  return 'https://en.wiktionary.org/wiki/' . $term;

}

1;
