package DDG::Goodie::Spell;

use DDG::Goodie;
use Text::Aspell;

triggers start => "spell", "how to spell", "how do i spell", "spellcheck";

zci is_cached => 1;

my $speller = Text::Aspell->new;
$speller->set_option('lang','en_US'); 
$speller->set_option('sug-mode','fast');

attribution 
    twitter => 'crazedpsyc',
    cpan    => 'CRZEDPSYC'
;

handle remainder => sub {
    return unless /^[\w']+$/; # only accept letters and ' (aspell handles contractions)
    my $correct = $speller->check($_) ? "'\u$_' appears to be spelled right!" : "'\u$_' does not appear to be spelled correctly.";
    my @suggestions = $speller->suggest($_);
    my $sug = @suggestions ? "Suggestions: " . join(', ', @suggestions[0..5]) : "No suggestions.";
    return "$correct  $sug", html => "$correct<br/>$sug";
};

1;
