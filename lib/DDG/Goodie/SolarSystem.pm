package DDG::Goodie::SolarSystem;
# ABSTRACT: Return various attributes of a object

use DDG::Goodie;
with 'DDG::GoodieRole::ImageLoader';
use YAML::XS qw( Load );
use POSIX;

zci answer_type => "solarsystem";
zci is_cached   => 1;

name "SolarSystem";
primary_example_queries 'size of venus';
secondary_example_queries 'what is the size of venus', 'volume of venus';
description 'Lookup various object attributes';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/objects.pm";
category 'random';
topics 'special_interest';
attribution github => ["MrChrisW", "Chris Wilson"],
            web => ["http://chrisjwilson.com", "Chris Wilson"];

my @triggers = ( 'earth', 'jupiter', 'mars', 'mercury', 'neptune', 'saturn', 'uranus', 'venus', 'pluto', 'sun', 'moon');

my @attributesArray = ( 'size', 'radius', 'volume', 'mass', 'surface area', 'area');

triggers any => @triggers;

# Load object data 
my $objects = Load(scalar share('objects.yml')->slurp);

# Handle statement
handle query_lc => sub {
  # Declare vars
  my ($attribute, $attributesString, $result, $objectObj, $image, $width, $height);
  
  s/^what is (the)|(of)|(object)//g; # Remove common words, strip question marks

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
  $objectObj = $objects->{$_}; # Get object data
  return unless $objectObj; # Return if we don't have a valid object

  # Switch to imperial for non-metric countries
  # https://en.wikipedia.org/wiki/Metrication
  if ($loc->country_code =~ m/US|MM|LR/i) {
    $result = $objectObj->{$attribute."_imperial"};
  } else {
    $result = $objectObj->{$attribute};
  }
  
  # Convert flag surface_area = Surface Area
  if($attribute =~ /_/ ) { $attribute = join ' ', map ucfirst lc, split /[_]+/, $attribute; }

  # Human friendly object name + attribute
  my $operation = ucfirst($_)." - ".ucfirst($attribute);

  # Superscript for km3, mi3, km2 or mi2 
  if($result =~ m/(km|mi)(\d)/) {
    my $symbol = $1; my $superscript = $2;
    $result =~ s/$symbol$superscript/$symbol<sup>$superscript<\/sup>/;
  }
  
  # Superscript for scientific notation
  # Convert x to HTML entity &times;
  if($result =~ m/x\s(10)(\d\d)/) {
    my $number = $1; my $exponent = $2;
    $result =~ s/$number$exponent/$number<sup>$exponent<\/sup>/;
    $result =~ s/x/&times;/;
  }

  #Change width for saturn image
  #Ensure we have a vaild image
  $width = ($_ eq "saturn") ? 45 : 40;
  $height = ($_ eq "saturn") ? 28 : 40;
  $image = goodie_img_tag({filename=>"/img/".$_.".png", height => $height, width => $width});
  return unless $image;

  #Return result and html
  return $operation." is ".$result, pretty_output($result, $operation, $image);
};


#Build HTML output
sub pretty_output {
  my ($result, $operation, $image) = @_;
  my $html = "<div class=\"zci--objects\">";
  $html .= "<span class=\"objects--objectImage\">";
  $html .= $image;
  $html .= "</span>";
  $html .= "<span class=\"objects--info\">";
  $html .= "<span class=\"text--primary objects--objectAttribute\">";
  $html .= $result;
  $html .= "</span>";
  $html .= "<span class=\"text--secondary objects--objectName\">";
  $html .= $operation;
  $html .= "</span>";
  $html .= "</span>";
  $html .= "</div>";
  return (html => $html);
}
1;