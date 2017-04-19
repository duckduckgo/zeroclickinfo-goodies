package DDG::Goodie::Catalan;
# ABSTRACT: Returns the Nth Catalan number

use DDG::Goodie;
use strict;
use ntheory qw(binomial);
use Lingua::EN::Numbers::Ordinate qw(ordsuf);

with 'DDG::GoodieRole::NumberStyler';

zci answer_type => 'catalan';
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
    return unless /^(?:what(?:'s| is) the )?(?<which>\d+)(?:th|rd|st)?(?: number)?(?: in the (?:series|sequence))?\??$/ && $1 <= 519;

    my $n = $+{'which'};
    my $style = number_style_for($n);
    return unless $style;
    
    $n = $style->for_computation($n);
    my $result = catalan($n);
    if ($result >= (10**11)) {
        $result = sprintf("%.10e", "$result");
    } else {
         $result = $style->for_display($result);
    }
    
    my $suf = ordsuf($n);
    my $subtitle = "$n$suf Catalan number.";
    return "The $n$suf catalan number is $result.",
      structured_answer => {
        id => 'catalan_number',
        name => 'Answer',
        data => {
            title => "$result",
            subtitle => $subtitle
        },
        templates => {
            group => 'text',
        }
        
      };
};

1;
