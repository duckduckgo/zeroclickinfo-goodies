package DDG::Goodie::Planets;
# ABSTRACT: Return various attributes of a planet

use DDG::Goodie;
with 'DDG::GoodieRole::ImageLoader';
use YAML::XS qw( Load );
use POSIX;
use DDG::Test::Location;

zci answer_type => "planets";
zci is_cached   => 1;

name "Planets";
primary_example_queries 'size of venus';
secondary_example_queries 'what is the size of venus', 'volume of venus';
description 'Lookup various attributes of planets';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Planets.pm";
category 'conversions';
topics 'special_interest';
attribution github => ["MrChrisW", "Chris Wilson"],
            web => ["http://chrisjwilson.com", "Chris Wilson"];

my @triggers = ( 'size', 'radius', 'volume', 'mass', 'temperature', 'surface area', 'area');
triggers any => @triggers;

my %planetImages = (
    earth => goodie_img_tag({filename => 'images/Earth.svg',height => 48, width => 48,}),
    jupiter => goodie_img_tag({filename => 'images/Jupiter.svg',height => 48, width => 48,}),
    mars => goodie_img_tag({filename => 'images/Mars.svg',height => 48, width => 48,}),
    mercury => goodie_img_tag({filename => 'images/Mercury.svg',height => 48, width => 48,}),
    neptune => goodie_img_tag({filename => 'images/Neptune.svg',height => 48, width => 48,}),
    saturn => goodie_img_tag({filename => 'images/Saturn.svg',height => 48, width => 48,}),
    uranus => goodie_img_tag({filename => 'images/Uranus.svg',height => 48, width => 48,}),
    venus => goodie_img_tag({filename => 'images/Venus.svg',height => 48, width => 48,})
);

# Load planet data 
my $planets = Load(scalar share('planets.yml')->slurp);

# Handle statement
handle query_lc => sub {

  s/\?//g; # Strip question marks.
  s/of|what|is|the//g; #remove common words

  #declare vars
  my ($flag, $result, $planetObj);

  # This is incorrect a query like "size volume size of mars" will choose the last flag value
  if (m/size/) { $flag = "radius" }
  if (m/radius/) { $flag = "radius" }
  if (m/volume/) { $flag = "volume" }
  if (m/mass/) { $flag = "mass" }
  if (m/area/) { $flag = "surface_area" }

  my $triggers = join('|', @triggers);
  s/$triggers//g; #remove keywords
  s/^\s+|\s+$//g; #trim

  return unless $_; # return if empty query
  $planetObj = $planets->{$_}; 
  return unless $planetObj; # return if we don't have a valid planet

  # Test Code # START
  my $test_location = test_location('au'); 
  my $location = $test_location->country_code;
  # Test Code # END

  #Switch to imperial for non-metric countries
  if ($location =~ m/UK|US|MM|LR/) { 
    $result = $planetObj->{$flag."_imperial"};
  } else {
    $result = $planetObj->{$flag};
  }
  #Convert any attributes to human friendly text. e.g surface_area = Surface Area
  if($flag =~ /_/ ) { $flag = join ' ', map ucfirst lc, split /[_]+/, $flag; }

  #Superscript for km3, mi3, km2 or mi2 - TODO: This is bad and broken
  if($result =~ m/km(\d)|mi(\d)/) {
    my $num = $1;
    my $notation = $&;
    $notation =~ s/$num//g;
    $result =~ s/$&/<sup>$num<\/sup>/g;
  }

  my $html = "<div class='zci--planets'>";
  $html .= "<span class=\"planets--planetImage\">";
  $html .= $planetImages{$_};
  $html .= "</span>";
  $html .= "<span class=\"planets--info\">";
  $html .= "<span class=\"text--primary planets--planetAttribute\">";
  $html .= $result;
  $html .= "</span>";
  $html .= "<span class=\"text--secondary planets--planetName\">";
  $html .= ucfirst($_).", ".ucfirst($flag);
  $html .= "</span>";
  $html .= "</span>";
  $html .= "</div>";
  return (html => $html);
};
1;
