package DDG::Goodie::UN;
# ABSTRACT: Gives a description for a given UN number

use DDG::Goodie;
use Number::UN 'get_un';

use constant WPHREF => "http://en.wikipedia.org/wiki/List_of_UN_numbers_%04d_to_%04d";

triggers start => 'un';

zci answer_type => 'united_nations';

handle remainder => sub {
  my $num = shift or return;
  my %un = get_un($num) or return;
  $un{description} =~ s/\.$//;
  return (sprintf qq(UN Number %04d - %s.), $num, $un{description}), html => sprintf qq(<a href="%s">UN Number %04d</a> - %s.), wphref($num), $num, $un{description};
};

# Wikipedia attribution per CC-BY-SA
sub wphref {
  my $num = shift;
  my $lower = int($num / 100) * 100 + 1;
  my $upper = $lower + 99;
  return sprintf WPHREF, $lower, $upper;
}

zci is_cached => 1;

1;
