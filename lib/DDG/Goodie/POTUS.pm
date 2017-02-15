package DDG::Goodie::POTUS;
# ABSTRACT: Returns requested President of the United States

use warnings;
use strict;
use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate qw(ordsuf ordinate);
use Lingua::EN::Words2Nums;
use YAML::XS 'LoadFile';

triggers startend => 'potus';
triggers any => 'president of the united states', 'president of the us';

zci answer_type => 'potus';
zci is_cached   => 1;

my @presidents = @{LoadFile(share('presidents.yml'))};
my $prez_count = scalar @presidents;

handle remainder => sub {
    my $rem = shift;

    $rem =~ s/
      |who\s+(is|was)\s*(the\s+)?
      |^POTUS\s+
      |\s+(POTUS|president\s+of\s+the\s+united\s+states)$
      |^(POTUS|president\s+of\s+the\s+united\s+states)\s+
    //gix;

    my $num = ($rem =~ /^\d+$/);
    $num = $prez_count if $rem eq "";
    $num = words2nums($rem) if words2nums($rem);
    return unless $num;

    my $index = $num - 1;
    return if $index < 0 or $index > $#presidents;

    my $fact = ($num == $prez_count ? 'is' : 'was') . ' the';

    my $POTUS   = 'President of the United States';
    my $the_guy = $presidents[$index];
    my $which   = ordinate($num);

    return "$the_guy $fact $which $POTUS", structured_answer => {
        data => {
            title => $the_guy,
            subtitle => "$which $POTUS",
        },
        templates => {
            group => 'text'
        }
    };
};

1;

