package DDG::Goodie::NthCatalan;

# ABSTRACT: Returns the Nth Catalan number

use DDG::Goodie;
use strict;
use ntheory qw(binomial);
use Lingua::EN::Numbers::Ordinate qw(ordsuf);
use bigint;

zci answer_type => 'nth_catalan';
zci is_cached => 1;

triggers any => 'catalan';

sub catalan {
  my $n = shift;
  binomial(2*$n,$n)/($n+1);
}

# Handle statement
handle remainder => sub {
    s/^\s+//;
    s/\s+$//;
    return unless /^(?:what(?:'s| is) the )?(?<which>\d+)(?:th|rd|st)?(?: number)?(?: in the (?:series|sequence))?\??$/ && $1 <= 1470000;

    my $n = $+{'which'};    
    my $suf = ordsuf($n);
    my $ans = catalan($n);

    return "The $n$suf catalan number is $ans.",
      structured_answer => {
        input     => [$n . $suf],
        operation => 'Catalan number',
        result    => "$ans",
      };
};

1;
