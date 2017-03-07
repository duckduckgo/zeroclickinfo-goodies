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
my $potus_or_president = qr/(potus|president of the (us|united states))/i;

handle query_lc => sub {

    # workaround for president-elect of the united states being classed as a trigger
    s/(^$potus_or_president\s)|(\s$potus_or_president\s?[\?]?$)//i;

    /^
      (who\s+(?<iswas>is|was)\s*(?:the\s*)?(?<num>.*))
      |(?<num>.*)
    $/gix or return;

    my $num;
    $num = $prez_count if $+{num} eq "";
    $num = $prez_count -1 if $+{num} eq "" and $+{iswas} eq "was";
    $num = words2nums($+{num}) if words2nums($+{num});
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

