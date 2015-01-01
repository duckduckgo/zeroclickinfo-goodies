package DDG::Goodie::Planets;
# ABSTRACT: Return various attributes of a planet

use DDG::Goodie;
use YAML::XS qw( Load );
use POSIX;

zci answer_type => "planets";
zci is_cached   => 1;

name "Planets";
primary_example_queries 'size of venus';
secondary_example_queries 'what is the size of venus', 'volume of venus';
description 'Lookup various attributes of planets';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Planets.pm";
category 'conversions';
topics 'special_interest';
attribution github => 'chrisjwilsoncom',
            twitter => 'chrisjwilsoncom';

my @triggers = qw(size radius volume mass);
triggers any => @triggers;

# Load planet data 
# https://en.wikipedia.org/wiki/List_of_gravitationally_rounded_objects_of_the_Solar_System
my $planets = Load(scalar share('planets.yml')->slurp);

# Handle statement
handle query_lc => sub {

  s/\?//g; # Strip question marks.
  s/of|what|is|the//g; #remove common words

  my $flag;

  # This is incorrect as a query like "size volume size of mars" will choose the last flag value
  
  if (m/size/) { $flag = "equatorial_radius" }
  if (m/radius/) { $flag = "equatorial_radius" }
  if (m/volume/) { $flag = "volume" }
  if (m/mass/) { $flag = "mass" }

  my $triggers = join('|', @triggers);
  s/$triggers//g; #remove keywords
  s/^\s+|\s+$//g; #trim

  return unless $_; 

  my $planetObj = $planets->{$_};

  my $kmValue = ceilCommify($planetObj->{equatorial_radius});
  my $mileValue = ceilCommify($planetObj->{equatorial_radius}* 0.6214);

  my $html = '<div>';
  $html .= '<div class="zci__caption">' .$kmValue. ' km (' .$mileValue. ' miles)</div>';
  $html .= '<div class="zci__subheader">' . ucfirst $_. ', Radius</div>';
  $html .= '</div>';

  return $planetObj->{equatorial_radius}, html => $html;
};
1;

sub ceilCommify {
    my $text = reverse ceil($_[0]);
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}