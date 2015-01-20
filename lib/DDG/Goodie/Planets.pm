package DDG::Goodie::Planets;
# ABSTRACT: Return various attributes of a planet

use DDG::Goodie;
with 'DDG::GoodieRole::ImageLoader';
use YAML::XS qw( Load );
use POSIX;

zci answer_type => "planets";
zci is_cached   => 1;

name "Planets";
primary_example_queries 'size of venus';
secondary_example_queries 'what is the size of venus', 'volume of venus';
description 'Lookup various planet attributes';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Planets.pm";
category 'random';
topics 'special_interest';
attribution github => ["MrChrisW", "Chris Wilson"],
            web => ["http://chrisjwilson.com", "Chris Wilson"];

my @triggers = ( 'earth', 'jupiter', 'mars', 'mercury', 'neptune', 'saturn', 'uranus', 'venus');

my @attributesArray = ( 'size', 'radius', 'volume', 'mass', 'surface area', 'area');

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
  # Declare vars
  my ($attribute, $attributesString, $result, $planetObj);
  
  s/what is (the)|(of)|(planet)//g; # Remove common words, strip question marks

  $attributesString = join('|', @attributesArray); 
  return unless /$attributesString/; # Ensure we match at least one attribute, eg. size, volume

  # Switch attribute depending on search query
  if(m/size|radius/) {$attribute = "radius"}
  elsif(m/volume/) {$attribute = "volume"}
  elsif(m/mass/) {$attribute = "mass"}
  elsif(m/area/) {$attribute = "surface_area"}

  s/$attributesString//g; # Remove attributes
  s/^\s+|\s+$//g; # Trim

  return unless $_; # Return if empty query
  $planetObj = $planets->{$_}; # Get planet data
  return unless $planetObj; # Return if we don't have a valid planet

  # Switch to imperial for non-metric countries
  # https://en.wikipedia.org/wiki/Metrication
  if ($loc->country_code =~ m/UK|US|MM|LR/i) {
    $result = $planetObj->{$attribute."_imperial"};
  } else {
    $result = $planetObj->{$attribute};
  }
  
  # Convert flag surface_area = Surface Area
  if($attribute =~ /_/ ) { $attribute = join ' ', map ucfirst lc, split /[_]+/, $attribute; }

  # Human friendly planet name + attribute
  my $operation = ucfirst($_).", ".ucfirst($attribute);

  # Superscript for km3, mi3, km2 or mi2 
  if($result =~ m/(km|mi)(\d)/) {
    my $notation = $1; my $num = $2;
    $result =~ s/$notation$num/$notation<sup>$num<\/sup>/;
  }

  #Return result and html
  return $operation." is ".$result, pretty_output($result, $operation, $planetImages{$_});

};

#Build HTML output
sub pretty_output {
  my ($result, $operation, $image) = @_;
  my $html = "<div class=\"zci--planets\">";
  $html .= "<span class=\"planets--planetImage\">";
  $html .= $image;
  $html .= "</span>";
  $html .= "<span class=\"planets--info\">";
  $html .= "<span class=\"text--primary planets--planetAttribute\">";
  $html .= $result;
  $html .= "</span>";
  $html .= "<span class=\"text--secondary planets--planetName\">";
  $html .= $operation;
  $html .= "</span>";
  $html .= "</span>";
  $html .= "</div>";
  return (html => $html);
}

1;