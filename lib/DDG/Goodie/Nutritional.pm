package DDG::Goodie::Nutritional;
# ABSTRACT: Food based nutritional information

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'nutritional';
zci is_cached => 1;

triggers any => 'nutrition';

my %info;
my $data = share('data/apple.csv')->slurp;
my @lines = split("\n", $data);

my $i = 0;
foreach(@lines) {
  
  if ($i == 0) {
      my @line = split(",", $_);
      shift @line;
      shift @line;
      map {
        $_ =~ s/^\s+|\s+$|"//g;
      } @line;
      $info{"headings"} = \@line;
  }

  if ($_ && scalar(split(",", $_)) > 1) {
      my @entry = split(",", $_);
      $entry[0] =~ s/^\s+|\s+$|"//g;
      my $type = $entry[0];
      shift @entry;
      $info{$type} = \@entry;
  }
  
  $i++;
}

handle query => sub {

    my $query = $_;

    return '',
        structured_answer => {

            data => {
                title    => 'Nutritional',
                subtitle => 'The new nutritional IA',
                information => \%info,
            },
            templates => {
                group => 'text',
                options => {
                    content => 'DDH.nutritional.content'
                }
            }
        };
};

1;
