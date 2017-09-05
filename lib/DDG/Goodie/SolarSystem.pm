package DDG::Goodie::SolarSystem;
# ABSTRACT: Return various attributes of an object

use DDG::Goodie;
use YAML::XS 'LoadFile';
use POSIX;
use Text::Trim;
use utf8;
use strict;

zci answer_type => "solarsystem";
zci is_cached   => 1;

# Get Goodie version for use with image paths
my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

my @attributesArray = ( 'size', 'radius', 'volume', 'mass', 'surface area', 'area');
my $attributesString = join('|', @attributesArray); 

my @unitTriggers = ( 'kg', 'km2', 'km3', 'km', 'mi2', 'mi3', 'mi', 'lbs', 'metric', 'imperial');
my $unitsString = join('|', @unitTriggers); 

triggers any => 'earth', 'jupiter', 'mars', 'mercury', 'neptune', 'saturn', 'uranus', 'venus', 'pluto', 'sun', 'moon';

# Load object data 
my $objects = LoadFile(share('objects.yml'));

# Handle statement
handle query_lc => sub {
    # Declare vars
    my ($attribute, $result, $objectObj, $objectName, $saturn, $unitType, $operation);
    
    s/(^what is)|(the)|(of)|(object)|(in)//g; # Remove common words

    return unless /$attributesString/; # Ensure we match at least one attribute, eg. size, volume

    # Set attribute depending on search query
    if(m/size|radius/) { $attribute = "radius" }
    elsif(m/volume/) { $attribute = "volume" }
    elsif(m/mass/) { $attribute = "mass" }
    elsif(m/area/) { $attribute = "surface_area" }

    s/$attributesString//g; # Remove attributes

    # Set unitType based on query string
    # kg, km, metric | lbs mi imperial
    if(m/kg|km\d?|metric/) {
        $unitType = $attribute;
    } elsif (m/lbs|mi\d?|imperial/) {
        $unitType = $attribute."_imperial";
    } else {
        # Switch to imperial for non-metric countries based on location
        # https://en.wikipedia.org/wiki/Metrication
        if ($loc->country_code =~ m/US|MM|LR/i) {
            $unitType = $attribute."_imperial";
        } else {
            $unitType = $attribute;
        }
    }

    s/$unitsString//g; # Remove unit/unit type
    trim($_); # Trim

    return unless $_; # Return if empty query
    $objectObj = $objects->{$_}; # Get object data
    return unless $objectObj; # Return if we don't have a valid object
    return unless $unitType; # Guard against no $unitType - should never occur
    $result = $objectObj->{$unitType}; # Get data using correct unit type 
    $objectName = $_;    
    
    # Convert attribute surface_area = Surface Area
    # Human friendly object name + attribute
    if($attribute =~ "surface_area") { $attribute = "Surface Area"; }
    $operation = ucfirst($_)." - ".ucfirst($attribute);

    # Superscript for km3, mi3, km2 or mi2 
    if($result =~ m/(km|mi)(\d)/) {
        my ($symbol, $superscript) = ($1, $2);
        my $unisuper = unicode_superscript($superscript);
        $result =~ s/$symbol$superscript/$symbol$unisuper/;
    }
    
    # Superscript for scientific notation
    # Convert x to unicode
    if($result =~ m/x\s(10)(\d\d)/) {
        my ($number, $exponent) = ($1, $2);
        my $uniexp = unicode_superscript($exponent);
        $result =~ s/$number$exponent/$number$uniexp/;
        $result =~ s/x/×/;
    }

    #$saturn var is provided to handlebars template to set size of image
    $saturn = ($objectName eq "saturn") ? 1 : 0;

    #Return result and html
    return $operation." is ".$result,
    structured_answer => {
        data => {
            attributes => $result,
            operation => $operation,
            imageName => $objectName,
            saturn => $saturn,
            goodie_version => $goodieVersion
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

sub unicode_superscript { return $_[0] =~ tr/0123456789/⁰ⁱ²³⁴⁵⁶⁷⁸⁹/r }
1;
