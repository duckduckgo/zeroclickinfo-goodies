package DDG::Goodie::POTUS;
# ABSTRACT: Returns requested President of the United States

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate qw(ordsuf ordinate);
use Lingua::EN::Words2Nums;
use YAML::XS qw( Load );

triggers startend => 'potus';
triggers any => 'president of the united states', 'president of the us';

zci answer_type => 'potus';
zci is_cached   => 1;

name 'POTUS';
description 'returns the President of the United States';
category 'reference';
topics 'trivia';
primary_example_queries 'potus 16';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/POTUS.pm';
attribution github  => ['numbertheory', 'John-Peter Etcheber'],
            twitter => ['jpscribbles', 'John-Peter Etcheber'];

my @presidents = @{Load(scalar share('presidents.yml')->slurp)};
my $prez_count = scalar @presidents;

handle remainder => sub {
    my $rem = shift;
    $rem =~ s/
      |who\s+(is|was)\s+the\s+
      |^POTUS\s+
      |\s+(POTUS|president\s+of\s+the\s+united\s+states)$
      |^(POTUS|president\s+of\s+the\s+united\s+states)\s+
    //gix;

    my $num = ($rem =~ /^\d+$/) ? $rem : words2nums($rem) || $prez_count;
    my $index = $num - 1;
    return if $index < 0 or $index > $#presidents;

    my $fact = ($num == $prez_count ? 'is' : 'was') . ' the';

    my $POTUS   = 'President of the United States';
    my $the_guy = $presidents[$index];
    my $which   = ordinate($num);

    return "$the_guy $fact $which $POTUS.",
      structured_answer => {
        input     => [$which],
        operation => $POTUS,
        result    => $the_guy,
      };
};

1;

