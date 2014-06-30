package DDG::Goodie::ChineseZodiac;
# ABSTRACT: Return the Chinese zodiac animal for a given year.

use DDG::Goodie;
use DateTime::Calendar::Chinese;
use DateTime::Event::Chinese qw(chinese_new_year_before chinese_new_year_after);
use utf8;
use feature 'state';

triggers any => 'chinese zodiac', 'shēngxiào', 'shengxiao', 'shēng xiào', 'sheng xiao';
zci is_cached => 1;

name 'Chinese Zodiac';
description 'Return the Chinese zodiac animal for a given year';
primary_example_queries 'chinese zodiac for 1969';
secondary_example_queries '2004 chinese zodiac animal', 'what was the chinese zodiac animal in 1992', 'what will the chinese zodiac animal be for 2056', 'last year\'s chinese zodiac';
category 'dates';
topics 'special_interest';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ChineseZodiac.pm';
attribution github => ['http://github.com/wilkox', 'wilkox'];

my %animal_to_language = (
  'hare' => { en => 'Rabbit', zh => '兔' },
  'dragon' => { en => 'Dragon', zh => '龙' },
  'snake' => { en => 'Snake', zh => '蛇' },
  'horse' => { en => 'Horse', zh => '马' },
  'sheep' => { en => 'Goat', zh => '羊' },
  'monkey' => { en => 'Monkey', zh => '猴' },
  'fowl' => { en => 'Rooster', zh => '鸡' },
  'dog' => { en => 'Dog', zh => '狗' },
  'pig' => { en => 'Pig', zh => '猪' },
  'rat' => { en => 'Rat', zh => '鼠' },
  'ox' => { en => 'Ox', zh => '牛' },
  'tiger' => { en => 'Tiger', zh => '虎' }
);

handle remainder => sub {

  #Figure out what year the user is interested in
  my $year_gregorian;

  #Return if more than one number has been included;
  # this IA only supports years (for now)
  return if /\d+[^\d]+\d+/;

  #Parse out a relative year expression if it was supplied
  if (/this\syear('s)?/) { 
    $year_gregorian = DateTime->now(time_zone => 'Asia/Shanghai') or return;
  } elsif (/next\syear('s)?/) {
    $year_gregorian = DateTime->now(time_zone => 'Asia/Shanghai')->add(years => 1) or return;
  } elsif (/last\syear('s)?/) {
    $year_gregorian = DateTime->now(time_zone => 'Asia/Shanghai')->subtract(years => 1) or return;

  #If no relative year was supplied, look for an explicit year
  # DateTime::Event::SolarTerm only supports 1900--2069, so 
  # return nothing if the user provides a year outside this range
  } elsif (/\b(\d+)\b/) {
    return unless $1 >= 1900 && $1 <= 2069;
    $year_gregorian = DateTime->new(year => $1, month => 6, time_zone => 'Asia/Shanghai');

  #Otherwise, default to now if it seems like the user is
  # asking a question about the current zodiac animal
  } elsif (/(what|which|year|animal|current|now|today|this)/)  {
    $year_gregorian = DateTime->now(time_zone => 'Asia/Shanghai') or return;
  
  #Don't want to show instant answer if user is just looking for
  # general information on the chinese zodiac
  } else {
    return;
  }

  #Find the Chinese year that aligns 
  # with the query (presumed Gregorian) year
  my $year_chinese = DateTime::Calendar::Chinese->from_object(object => $year_gregorian);

  #Get the inclusive Gregorian date range for the Chinese year
  #Note that returned dates will be for the 'Asia/Shanghai'
  # time zone (China Standard Time/CST) as this is where
  # Chinese New Year is calculated
  my $year_start = chinese_new_year_before($year_gregorian)->set_time_zone('Asia/Shanghai');
  my $year_end = chinese_new_year_after($year_gregorian)->subtract(days => 1)->set_time_zone('Asia/Shanghai');

  my $animal = $year_chinese->zodiac_animal;
  my $english = $animal_to_language{$animal}{'en'};
  my $character = $animal_to_language{$animal}{'zh'};

  my $statement = 'Chinese zodiac animal for ' . format_datetime($year_start) . "\x{2013}" . format_datetime($year_end);

  return answer => $english, html => wrap_html($character, $english, $statement);
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
  my ($character, $english, $statement) = @_;
  return append_css("<div class='zci--chinesezodiac'><div class='zodiaccharacter'>$character ($english)</div><span class='statement'>$statement</span></div>");
}

1;
