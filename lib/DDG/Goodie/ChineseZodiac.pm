package DDG::Goodie::ChineseZodiac;
# ABSTRACT: Return the Chinese zodiac animal for a given year.

use DDG::Goodie;
use DateTime::Calendar::Chinese;
use DateTime::Event::Chinese qw(chinese_new_year_before chinese_new_year_after);
use utf8;
use feature 'state';

triggers any => 'chinese zodiac';
zci is_cached => 1;

name 'Chinese Zodiac';
description 'Return the Chinese zodiac animal for a given year';
primary_example_queries 'chinese zodiac for 1969';
secondary_example_queries '2004 chinese zodiac animal', 'what was the chinese zodiac animal in 1992', 'what will the chinese zodiac animal be for 2056';
category 'dates';
topics 'special_interest';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ChineseZodiac.pm';
attribution github => ['http://github.com/wilkox', 'wilkox'];

my %standard = (
  'hare' => 'Rabbit',
  'dragon' => 'Dragon',
  'snake' => 'Snake',
  'horse' => 'Horse',
  'sheep' => 'Goat',
  'monkey' => 'Monkey',
  'fowl' => 'Rooster',
  'dog' => 'Dog',
  'pig' => 'Pig',
  'rat' => 'Rat',
  'ox' => 'Ox',
  'tiger' => 'Tiger'
);

my %character = (
  'Rabbit' => "\x{5154}",
  'Dragon' => "\x{9F99}",
  'Snake' => "\x{86C7}",
  'Horse' => "\x{9A6C}",
  'Goat' => "\x{7F8A}",
  'Monkey' => "\x{7334}",
  'Rooster' => "\x{9E21}",
  'Dog' => "\x{72D7}",
  'Pig' => "\x{732A}",
  'Rat' => "\x{9F20}",
  'Ox' => "\x{725B}",
  'Tiger' => "\x{864E}"
);

handle remainder => sub {

  #Remove extra words if supplied
  $_ =~ s/(what)?
          (is)?
          (was)?
          (will)?
          (the)?
          (be)?
          (animal)?
          (for)?
          (of)?
          (a)?
          (people|someone|person)?
          (born)?
          (in)?
          (year)?
        //gix;

  #Remove whitespace
  $_ =~ s/\s//g;

  #Must be a year in the current era (0-9999)
  return unless $_ =~ /^\d{1,4}$/;

  #Find the Chinese year that aligns 
  # with the query (presumed Gregorian) year
  my $year_gregorian = DateTime->new(year => $_, month => 6, time_zone => 'Asia/Shanghai');
  my $year_chinese = DateTime::Calendar::Chinese->from_object(object => $year_gregorian);

  #Get the inclusive Gregorian date range for the Chinese year
  #Note that returned dates will be for the 'Asia/Shanghai'
  # time zone (China Standard Time/CST) as this is where
  # Chinese New Year is calculated
  my $year_start = chinese_new_year_before($year_gregorian)->set_time_zone('Asia/Shanghai');
  my $year_end = chinese_new_year_after($year_gregorian)->subtract(days => 1)->set_time_zone('Asia/Shanghai');

  my $animal = $standard{$year_chinese->zodiac_animal};
  my $character = $character{$animal};

  my $statement = 'Chinese zodiac animal for ' . format_datetime($year_start) . "\x{2013}" . format_datetime($year_end);

  return answer => $animal, html => wrap_html($character, $animal, $statement);
};

sub format_datetime {
  my $dt = shift;
  my $formatted = $dt->strftime('%b %e, %Y');
  $formatted =~ s/\s\s/ /g;
  return $formatted;
}

# This function adds some HTML and styling to our output
# so that we can make it prettier (copied from the Conversions
# goodie)
sub append_css {
  my $html = shift;
  state $css = share("style.css")->slurp;
  return "<style type='text/css'>$css</style>$html";
}

sub wrap_html {
  my ($character, $animal, $statement) = @_;
  return append_css("<div class='zci--chinesezodiac'><div class='zodiaccharacter'>$character ($animal)</div><span class='statement'>$statement</span></div>");
}

1;
