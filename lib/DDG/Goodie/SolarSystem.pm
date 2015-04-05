package DDG::Goodie::SolarSystem;
# ABSTRACT: Return various attributes of a object

use DDG::Goodie;
use YAML::XS qw( Load );
use POSIX;
use List::Util qw'first';

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

my @unitTriggers = ( 'kg', 'km2', 'km3', 'km', 'mi2', 'mi3', 'mi', 'lbs', 'metric', 'imperial');

triggers any => @triggers;

# Load object data 
my $objects = Load(scalar share('objects.yml')->slurp);

# Handle statement
handle query_lc => sub {
  # Declare vars
  my ($attribute, $attributesString, $unitsString, $result, $objectObj, $objectName, $saturn, $unitType);
  
  s/^what is (the)|(of)|(object)//g; # Remove common words, strip question marks

  $attributesString = join('|', @attributesArray); 
  return unless /$attributesString/; # Ensure we match at least one attribute, eg. size, volume

  $unitsString = join('|', @unitTriggers); 

  # Set attribute depending on search query
  if(m/size|radius/) {$attribute = "radius"}
  elsif(m/volume/) {$attribute = "volume"}
  elsif(m/mass/) {$attribute = "mass"}
  elsif(m/area/) {$attribute = "surface_area"}

  s/$attributesString//g; # Remove attributes

  # Switch unit type based on user input
  # kg, km, metric | lbs mi imperial
  if(m/kg|km\d?|metric/) {
    $unitType = $attribute;
  } elsif (m/lbs|mi\d?|imperial/) {
    $unitType = $attribute."_imperial";
  } 

  s/$unitsString//g; # Remove unit/unit type
  s/^\s+|\s+$//g; # Trim

  return unless $_; # Return if empty query
  $objectObj = $objects->{$_}; # Get object data
  return unless $objectObj; # Return if we don't have a valid object
  $objectName = $_;

  # Switch to imperial for non-metric countries
  # https://en.wikipedia.org/wiki/Metrication
  if (!$unitType)
  {
    if ($loc->country_code =~ m/US|MM|LR/i) {
      $unitType = $attribute."_imperial";
    } else {
      $unitType = $attribute;
    }
  }

  # Get correct unit type 
  $result = $objectObj->{$unitType};
  
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

  #$saturn var is provided to handlebars template to set size of image
  $saturn = ($objectName eq "saturn") ? 1 : 0;

  #Return result and html
      return $operation." is ".$result,
        structured_answer => {
            id => 'solar_system',
            name => 'Answer',
            data => {
                attributes => $result,
                operation => $operation,
                imageName => $objectName,
                saturn => $saturn
            },
            meta => {
                sourceUrl => "https://solarsystem.nasa.gov/planets/index.cfm",
                sourceName => "NASA"
            },
            templates => {
                group => 'base',
                detail_mobile => 'DDH.solar_system.mobile',
                options => {
                    content => 'DDH.solar_system.content',
                }
            }
        };
};
1;