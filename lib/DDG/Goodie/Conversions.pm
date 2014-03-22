package DDG::Goodie::Conversions;
# ABSTRACT: convert between various units of measurement

use DDG::Goodie;
use Scalar::Util qw/looks_like_number/;
use Data::Float qw/float_is_infinite float_is_nan/;
use Math::Round qw/nearest/;

###@todo
###    --  1 -- include more unit types
###             see: https://github.com/duckduckgo/zeroclickinfo-goodies/issues/318
###             + currently missing only [area/volume] and [velocity]
###    --  3 -- would like to handle things like "6^2 g to oz" (present undef;)

name                      'Conversions';
description               'convert between various units of measurement';
category                  'calculations';
topics                    'computing', 'math';
primary_example_queries   'convert 5 oz to grams';
secondary_example_queries '5 ounces to g', '0.5 nautical miles in km';
code_url                  'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Conversions.pm';
attribution                github  => ['https://github.com/elohmrow', 'https://github.com/mintsoft'],
                           email   => ['bradley@pvnp.us'];

zci answer_type => 'conversions';

# metric ton is base unit for mass
# known SI units and aliases / plurals
my @mass = (
    {
        'unit'    => 'metric ton',
        'factor'  => '1',
        'aliases' => ['tonne', 't', 'mt', 'te', 'metric tons', 'tonnes', 'ts', 'mts', 'tes'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'ounce',
        'factor'  => '35274',
        'aliases' => ['oz', 'ounces', 'ozs'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'pound',
        'factor'  => '2204.62',
        'aliases' => ['lb', 'lbm', 'pound mass', 'pounds', 'lbs', 'lbms', 'pounds mass'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'stone',
        'factor'  => '157.473',
        'aliases' => ['st', 'stones', 'sts'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'long ton',
        'factor'  => '0.984207',
        'aliases' => ['weight ton', 'imperial ton', 'long tons', 'weight tons', 'imperial tons'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'microgram',
        'factor'  => '1000000000',
        'aliases' => ['mcg', 'micrograms', 'mcgs'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'kilogram',
        'factor'  => '1000',
        'aliases' => ['kg', 'kilo', 'kilogramme', 'kilograms', 'kgs', 'kilos', 'kilogrammes'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'gram',
        'factor'  => '1000000',
        'aliases' => ['g', 'gm', 'gramme', 'grams', 'gs', 'gms', 'grammes'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'milligram',
        'factor'  => '1000000000',
        'aliases' => ['mg', 'milligrams', 'mgs'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'ton',
        'factor'  => '1.10231',
        'aliases' => ['short ton', 'short tons', 'tons'],
        'type'    => 'mass',
    },
);

# meter is the base unit for length
# known SI units and aliases / plurals
my @length = (
    {
        'unit'      => 'meter',
        'factor'    => '1',
        'aliases'   => ['meters', 'metre', 'metres', 'm', 'ms'],
        'type'      => 'length',
    },
    {
        'unit'      => 'kilometer',
        'factor'    => '0.001',
        'aliases'   => ['kilometers', 'kilometre', 'kilometres', 'km', 'kms', 'klick', 'klicks'],
        'type'      => 'length',
    },
    {
        'unit'      => 'centimeter',
        'factor'    => '100',
        'aliases'   => ['centimeters', 'centimetre', 'centimetres', 'cm', 'cms'],
        'type'      => 'length',
    },
    {
        'unit'      => 'millimeter',
        'factor'    => '1000',
        'aliases'   => ['millimeters', 'millimetre', 'millimetres', 'mm', 'mms'],
        'type'      => 'length',
    },
    {
        'unit'      => 'mile',
        'factor'    => '0.000621371',
        'aliases'   => ['miles', 'statute mile', 'statute miles', 'land mile', 'land miles'],
        'type'      => 'length',
    },
    {
        'unit'      => 'yard',
        'factor'    => '1.09361',
        'aliases'   => ['yards', 'yd', 'yds', 'yrds'],
        'type'      => 'length',
    },
    {
        'unit'      => 'foot',
        'factor'    => '3.28084',
        'aliases'   => ['feet', 'ft', 'international foot', 'international feet', 'survey foot', 'survey feet'],
        'type'      => 'length',
    },
    {
        'unit'      => 'inch',
        'factor'    => '39.3701',
        'aliases'   => ['inches', 'in', 'ins'],
        'type'      => 'length',
    },
    {
        'unit'      => 'nautical mile',
        'factor'    => '0.000539957',
        'aliases'   => ['nautical miles', 'n', 'ns', 'nm', 'nms', 'nmi', 'nmis'],
        'type'      => 'length',
    },
    {
        'unit'      => 'furlong',
        'factor'    => (1/201.168),
        'aliases'   => ['furlongs'],
        'type'      => 'length',
    },
    {
        'unit'      => 'chain',
        'factor'    => (1/20.1168),
        'aliases'   => ["gunter's chains", 'chains'],
        'type'      => 'length',
    },
    {
        'unit'      => 'link',
        'factor'    => (1/0.201168),
        'aliases'   => ["gunter's links", 'links'],
        'type'      => 'length',
    },
    {
        'unit'      => 'rod',
        'factor'    => 1/(5.0292),
        'aliases'   => ['rods'],
        'type'      => 'length',
    },
    {
        'unit'      => 'fathom',
        'factor'    => 1/(1.853184),
        'aliases'   => ['fathoms', 'ftm', 'ftms'],
        'type'      => 'length',
    },
    {
        'unit'      => 'league',
        'factor'    => 1/(4828.032),
        'aliases'   => ['leagues'],
        'type'      => 'length',
    },
    {
        'unit'      => 'cable',
        'factor'    => 1/(185.3184),
        'aliases'   => ['cables'],
        'type'      => 'length',
    },
    {
        'unit'      => 'light year',
        'factor'    => (1/9460730472580800),
        'aliases'   => ['light years', 'ly', 'lys'],
        'type'      => 'length',
    },
    {
        'unit'      => 'parsec',
        'factor'    => (1/30856776376340067),
        'aliases'   => ['parsecs', 'pc', 'pcs'],
        'type'      => 'length',
    },
    {
        'unit'      => 'astronomical unit',
        'factor'    => (1/149597870700),
        'aliases'   => ['astronomical units', 'au', 'aus'],
        'type'      => 'length',
    },
);

# day is base unit for time
# known SI units and aliases / plurals
my @time = (
    {
        'unit'      => 'day',
        'factor'    => '1',
        'aliases'   => ['days', 'dy', 'dys', 'd'],
        'type'      => 'duration',
    },
    {
        'unit'      => 'second',
        'factor'    => '86400',
        'aliases'   => ['seconds', 'sec', 's'],
        'type'      => 'duration',
    },
    {
        'unit'      => 'millisecond',
        'factor'    => '86400000',
        'aliases'   => ['milliseconds', 'millisec', 'millisecs', 'ms'],
        'type'      => 'duration',
    },
    {
        'unit'      => 'microsecond',
        'factor'    => '86400000000',
        'aliases'   => ['microseconds', 'microsec', 'microsecs', 'us'],
        'type'      => 'duration',
    },
    {
        'unit'      => 'minute',
        'factor'    => '1440',
        'aliases'   => ['minutes', 'min', 'mins'],
        'type'      => 'duration',
    },
    {
        'unit'      => 'hour',
        'factor'    => '24',
        'aliases'   => ['hours', 'hr', 'hrs', 'h'],
        'type'      => 'duration',
    },
    {
        'unit'      => 'week',
        'factor'    => 1/7,
        'aliases'   => ['weeks', 'wks', 'wk'],
        'type'      => 'duration',
    },
    {
        'unit'      => 'fortnight',
        'factor'    => 1/14,
        'aliases'   => [],
        'type'      => 'duration',
    },
    {    # a month being defined as an average earth month (30.42)
        'unit'      => 'month',
        'factor'    => 1/30.42,
        'aliases'   => ['months', 'mons', 'mns', 'mn'],
        'type'      => 'duration',
    },
    {
        'unit'      => 'year',
        'factor'    => 1/365,
        'aliases'   => ['years', 'yr', 'yrs'],
        'type'      => 'duration',
    },
    {
        'unit'      => 'leap year',
        'factor'    => 1/366,
        'aliases'   => ['leap years', 'leapyear', 'leapyr', 'leapyrs'],
        'type'      => 'duration',
    },
);

# pascal is base unit for pressure
# known SI units and aliases / plurals
my @pressure = (
    {
        'unit'      => 'pascal',
        'factor'    => 1,
        'aliases'   => ['pascals', 'pa', 'pas'],
        'type'      => 'pressure',
    },
    {
        'unit'      => 'kilopascal',
        'factor'    => (1/1000),
        'aliases'   => ['kilopascals', 'kpa', 'kpas'],
        'type'      => 'pressure',
    },
    {
        'unit'      => 'megapascal',
        'factor'    => (1/1_000_000),
        'aliases'   => ['megapascals', 'megapa', 'megapas'],
        'type'      => 'pressure',
    },
    {
        'unit'      => 'gigapascal',
        'factor'    => (1/1_000_000_000),
        'aliases'   => ['gigapascals', 'gpa', 'gpas'],
        'type'      => 'pressure',
    },
    {
        'unit'      => 'bar',
        'factor'    => 1/(100_000),
        'aliases'   => ['bars', 'pa', 'pas'],
        'type'      => 'pressure',
    },
    {
        'unit'      => 'atmosphere',
        'factor'    => 1/(101_325),
        'aliases'   => ['atmospheres', 'atm', 'atms'],
        'type'      => 'pressure',
    },
    {
        'unit'      => 'pounds per square inch',
        'factor'    => 1/6894.8,
        'aliases'   => ['psis', 'psi', 'lbs/inch^2', 'p.s.i.', 'p.s.i'],
        'type'      => 'pressure',
    },
);

# joule is base unit for energy
# known SI units and aliases / plurals
my @energy = (
    {
        'unit'      => 'joule',
        'factor'    => 1,
        'aliases'   => ['joules', 'j', 'js'],
        'type'      => 'energy',
    },
    {
        'unit'      => 'watt-second',
        'factor'    => (1),
        'aliases'   => ['watt second', 'watt seconds', 'ws'],
        'type'      => 'energy',
    },
    {
        'unit'      => 'watt-hour',
        'factor'    => (1/3600),
        'aliases'   => ['watt hour', 'watt hours', 'wh'],
        'type'      => 'energy',
    },
    {
        'unit'      => 'kilowatt-hour',
        'factor'    => (1/3_600_000),
        'aliases'   => ['kilowatt hour', 'kilowatt hours', 'kwh'],
        'type'      => 'energy',
    },
    {
        'unit'      => 'erg',
        'factor'    => (1/10_000_000),
        'aliases'   => ['ergon', 'ergs', 'ergons'],
        'type'      => 'energy',
    },
    {
        'unit'      => 'electron volt',
        'factor'    => (6.2415096e+18),
        'aliases'   => ['electronvolt', 'electron volts', 'ev', 'evs'],
        'type'      => 'energy',
    },
    {
        'unit'      => 'thermochemical gram calorie',
        'factor'    => (1/4.184),
        'aliases'   => ['small calories', 'thermochemical gram calories', 'chemical calorie', 'chemical calories'],
        'type'      => 'energy',
    },
    {
        'unit'      => 'large calorie',
        'factor'    => (1/4184),
        'aliases'   => ['large calories', 'food calorie', 'food calories', 'kcals', 'kcal'],
        'type'      => 'energy',
    },
    {
        'unit'      => 'british thermal unit',
        'factor'    => (1/1054.5),
        'aliases'   => ['british thermal units', 'btu', 'btus'],
        'type'      => 'energy',
    },
    {
        'unit'      => 'ton of TNT',
        'factor'    => (1/4.184e+9),
        'aliases'   => ['tnt equivilent', 'tonnes of tnt', 'tnt', 'tons of tnt'],
        'type'      => 'energy',
    }
);

# watt is base unit for power
# known SI units and aliases / plurals
my @power = (
    {
        'unit'      => 'watt',
        'factor'    => 1,
        'aliases'   => ['watts', 'w'],
        'type'      => 'power',
    },
    {
        'unit'      => 'kilowatt',
        'factor'    => 1/1000,
        'aliases'   => ['kilowatts', 'kw'],
        'type'      => 'power',
    },
    {
        'unit'      => 'megawatt',
        'factor'    => 1/1_000_000,
        'aliases'   => ['megawatts', 'mw'],
        'type'      => 'power',
    },
    {
        'unit'      => 'gigawatt',
        'factor'    => 1/1_000_000_000,
        'aliases'   => ['gigawatts', 'jiggawatts', 'gw'],
        'type'      => 'power',
    },
    {
        'unit'      => 'terawatt',
        'factor'    => 1/1_000_000_000_000,
        'aliases'   => ['terawatts', 'tw'],
        'type'      => 'power',
    },
    {
        'unit'      => 'petawatt',
        'factor'    => 1/1_000_000_000_000_000,
        'aliases'   => ['petawatts', 'pw'],
        'type'      => 'power',
    },
    {
        'unit'      => 'milliwatt',
        'factor'    => 1000,
        'aliases'   => ['milliwatts'],
        'type'      => 'power',
    },
    {
        'unit'      => 'microwatt',
        'factor'    => 1_000_000,
        'aliases'   => ['microwatts'],
        'type'      => 'power',
    },
    {
        'unit'      => 'nanowatt',
        'factor'    => 1_000_000_000,
        'aliases'   => ['nanowatts', 'nw'],
        'type'      => 'power',
    },
    {
        'unit'      => 'picowatt',
        'factor'    => 1_000_000_000_000,
        'aliases'   => ['picowatts', 'pw'],
        'type'      => 'power',
    },
    {
        'unit'      => 'metric horsepower',
        'factor'    => (1/735.49875),
        'aliases'   => ['metric horsepowers', 'mhp', 'hp', 'ps', 'cv', 'hk', 'ks', 'ch'],
        'type'      => 'power',
    },
    {
        'unit'      => 'horsepower',
        'factor'    => (1/745.69987158227022),
        'aliases'   => ['mechnical horsepower', 'horsepower', 'hp', 'hp', 'bhp'],
        'type'      => 'power',
    },
    {
        'unit'      => 'electical horsepower',
        'factor'    => (1/746),
        'aliases'   => ['electical horsepowers', 'hp', 'hp'],
        'type'      => 'power',
    },
);

# degree is base unit for angles
# known SI units and aliases / plurals
my @angle = (
    {
        'unit'      => 'degree',
        'factor'    => 1,
        'aliases'   => ['degrees', 'deg', 'degs'],
        'type'      => 'angle',
    },
    {
        'unit'      => 'radian',
        'factor'    => 3.14159265358979323/180,
        'aliases'   => ['radians', 'rad', 'rads'],
        'type'      => 'angle',
    },
    {
        'unit'      => 'gradian',
        'factor'    => 10/9,
        'aliases'   => ['gradians', 'grad', 'grads', 'gon', 'gons', 'grade', 'grades'],
        'type'      => 'angle',
    },
    {
        'unit'      => 'quadrant',
        'factor'    => 1/90,
        'aliases'   => ['quadrants', 'quads', 'quad'],
        'type'      => 'angle',
    },
    {
        'unit'      => 'semi-circle',
        'factor'    => 1/180,
        'aliases'   => ['semi circle', 'semicircle','semi circles', 'semicircles', 'semi-circles'],
        'type'      => 'angle',
    },
    {
        'unit'      => 'revolution',
        'factor'    => 1/360,
        'aliases'   => ['revolutions', 'circle', 'circles', 'revs'],
        'type'      => 'angle',
    },
);

# newton is base unit for force
# known SI units and aliases / plurals
my @force = (
    {
        'unit'      => 'newton',
        'factor'    => 1,
        'aliases'   => ['newtons', 'n'],
        'type'      => 'force',
    },
    {
        'unit'      => 'kilonewton',
        'factor'    => 1/1000,
        'aliases'   => ['kilonewtons', 'kn'],
        'type'      => 'force',
    },
    {
        'unit'      => 'meganewton',
        'factor'    => 1/1_000_000,
        'aliases'   => ['meganewtons', 'mn'],
        'type'      => 'force',
    },
    {
        'unit'      => 'giganewton',
        'factor'    => 1/1_000_000_000,
        'aliases'   => ['giganewtons', 'gn'],
        'type'      => 'force',
    },
    {
        'unit'      => 'dyne',
        'factor'    => 1/100000,
        'aliases'   => ['dynes'],
        'type'      => 'force',
    },
    {
        'unit'      => 'kilodyne',
        'factor'    => 1/100,
        'aliases'   => ['kilodynes'],
        'type'      => 'force',
    },
    {
        'unit'      => 'megadyne',
        'factor'    => 10,
        'aliases'   => ['megadynes'],
        'type'      => 'force',
    },
    {
        'unit'      => 'pounds force',
        'factor'    => 1/4.4482216152605,
        'aliases'   => ['lbs force', 'pounds force'],
        'type'      => 'force',
    },
    {
        'unit'      => 'poundal',
        'factor'    => 1/0.138254954376,
        'aliases'   => ['poundals', 'pdl'],
        'type'      => 'force',
    },
);

# fahrenheit is base unit for temperature
# known SI units and aliases / plurals
my @temperature = (
    {   
        'unit'            => 'fahrenheit',
        'factor'          => 1,           # all '1' because un-used
        'aliases'         => ['f'],     
        'type'            => 'temperature',
        'can_be_negative' => 1,
    },
    {   
        'unit'            => 'celsius',
        'factor'          => 1,           
        'aliases'         => ['c'],
        'type'            => 'temperature',
        'can_be_negative' => 1,
    },
    {
        'unit'            => 'kelvin',
        'factor'          => 1,
        'aliases'         => ['k'],       # be careful ... other units could use 'K'
        'type'            => 'temperature',       
    },
    {
        'unit'            => 'rankine',
        'factor'          => 1,
        'aliases'         => ['r'],    
        'type'            => 'temperature',
    },
    {
        'unit'            => 'reaumur',
        'factor'          => 1,
        'aliases'         => ['re'],      # also can be 'R', but that's being used for rankine    
        'type'            => 'temperature',
        'can_be_negative' => 1,
    },
);  

# build the keys:
my @types = (@mass, @length, @time, @pressure, @energy, @power, @angle, @force, @temperature);    # unit types available for conversion
my @units = ();
foreach my $type (@types) {
    push(@units, $type->{'unit'});
    push(@units, @{$type->{'aliases'}});
}

# build triggers based on available conversion units:
triggers end => @units;

# match longest possible key (some keys are sub-keys of other keys):
my $keys = join '|', reverse sort { length($a) <=> length($b) } @units;

# guards and matches regex
my $guard = qr/^(convert\s)?[0-9\.]+\s?($keys)\s?(in|to|into|from)\s?[0-9\.]*\s?($keys)+$/;
my $match_regex = qr/(?:[0-9]|\b)($keys)\b/;

# exceptions for pluralized forms:
my %plural_exceptions = (
    'stone'                  => 'stone',
    'foot'                   => 'feet',
    'inch'                   => 'inches',
    'pounds per square inch' => 'pounds per square inch',
    'ton of TNT'             => 'tons of TNT',
    'metric horsepower'      => 'metric horsepower',
    'horsepower'             => 'horsepower',
    'electrical horsepower'  => 'electrical horsepower',
    'pounds force'           => 'pounds force',
);

#
#   helper function:
#       [1] get factors for later calculating conversion
#       [2] get trigger 'types' to determine if we can perform a calculation in the first place
#       [3] get canoncial units for massaging output
#       [4] determine if a unit may be negative 
#
sub get_matches {
    my $matches = shift;
    my @matches = @{$matches};

    my @match_types = ();
    my @factors = ();
    my @units = ();
    my @can_be_negative = ();
    
    foreach my $match (@matches) {
        foreach my $type (@types) {
            if ($match eq $type->{'unit'} || grep { $_ eq $match } @{$type->{'aliases'}}) {
                push(@match_types, $type->{'type'});
                push(@factors, $type->{'factor'});
                push(@units, $type->{'unit'});
                push(@can_be_negative, $type->{'can_be_negative'} || '0');
            }
        }
    }
   
    return if scalar(@match_types) != 2; 
    return if scalar(@factors) != 2;
    return if scalar(@units) != 2;
    return if scalar(@can_be_negative) != 2;
    
    my %matches = (
        'type_1'            => $match_types[0],
        'type_2'            => $match_types[1],
        'factor_1'          => $factors[0],
        'factor_2'          => $factors[1],
        'from_unit'         => $units[0],
        'to_unit'           => $units[1],
        'can_be_negative_1' => $can_be_negative[0],
        'can_be_negative_2' => $can_be_negative[1],
    );

    return \%matches;
}

sub convert_temperatures {
    # ##
    # F  = (C * 1.8) + 32            # celsius to fahrenheit
    # F  = 1.8 * (K - 273.15) + 32   # kelvin  to fahrenheit
    # F  = R - 459.67                # rankine to fahrenheit
    # F  = (Ra * 2.25) + 32          # reaumur to fahrenheit
    #
    # C  = (F - 32) * 0.555          # fahrenheit to celsius
    # K  = (F + 459.67) * 0.555      # fahrenheit to kelvin
    # R  = F + 459.67                # fahrenheit to rankine
    # Ra = (F - 32) * 0.444          # fahrenheit to reaumur
    # ##

    my $from = shift;
    my $to = shift;
    my $factor = shift;
    
    # convert $from to fahrenheit:
    if    ($from =~ /fahrenheit|f/i) { $factor = $factor;                       }
    elsif ($from =~ /celsius|c/i)    { $factor = ($factor * 1.8) + 32;          }
    elsif ($from =~ /kelvin|k/i)     { $factor = 1.8 * ($factor - 273.15) + 32; }
    elsif ($from =~ /rankine|r/i)    { $factor = $factor - 459.67;              }
    else                             { $factor = ($factor * 2.25) + 32;         }    # reaumur 
    
    # convert fahrenheit $to:
    if    ($to   =~ /fahrenheit|f/i) { $factor = $factor;                       }
    elsif ($to   =~ /celsius|c/i)    { $factor = ($factor - 32) * 0.555;        }
    elsif ($to   =~ /kelvin|k/i)     { $factor = ($factor + 459.67) * 0.555;    }
    elsif ($to   =~ /rankine|r/i)    { $factor = $factor + 459.67;              }
    else                             { $factor = ($factor - 32) * 0.444;        }    # reaumur 

    return $factor;
}

handle query_lc => sub {
    # hack around issues with feet and inches for now
    s/"/inches/;
    s/'/feet/;
    
    # guard the query from spurious matches
    return unless /$guard/;
    
    my @matches = ($_ =~ /$match_regex/gi);
    
    # hack/handle the special case of "X in Y":
    if ((scalar @matches == 3) && $matches[1] eq "in") {
        @matches = ($matches[0], $matches[2]);
    }
    return unless scalar @matches == 2; # conversion requires two triggers

    my $matches = get_matches(\@matches);
    
    # normalize the whitespace, "25cm" should work for example
    s/([0-9])([a-zA-Z])/$1 $2/;
    
    # get factor:
    my @args = split(/\s+/, $_);
    my $factor = 1;
    foreach my $arg (@args) {
        if (looks_like_number($arg)) {
            # looks_like_number thinks 'Inf' and 'NaN' are numbers:
            return if float_is_infinite($arg) || float_is_nan($arg);

            $factor = $arg unless $factor != 1;     # drop n > 1 #s
            
            return if $factor < 0 && !($matches->{'can_be_negative_1'} && $matches->{'can_be_negative_2'}); 
        }
        else {
            # if it doesn't look like a number, and it contains a number (e.g., '6^2'):
            return if $arg =~ /\d/;
        }
    }

    # matches must be of the same type (e.g., can't convert mass to length):
    return if ($matches->{'type_1'} ne $matches->{'type_2'});
    
    # run the conversion:
    # temperatures don't have 1:1 conversions, so they get special treatment:
    if ($matches->{'type_1'} eq 'temperature') {
        return "$factor degrees $matches->{'from_unit'} is " . sprintf("%.3f", convert_temperatures($matches->{'from_unit'}, $matches->{'to_unit'}, $factor)) . " degrees $matches->{'to_unit'}";
    }

    # handle plurals:
    my $result = $factor * ($matches->{'factor_2'} / $matches->{'factor_1'});
    # if $result = 1.00000 .. 000n, where n <> 0 then $result != 1 and throws off pluralization, so:
    $result = nearest(.001, $result);   # .001 to match sprintf "%.3f" below
    
    if ($factor != 1) {
        $matches->{'from_unit'} = (exists $plural_exceptions{$matches->{'from_unit'}}) ? $plural_exceptions{$matches->{'from_unit'}} : $matches->{'from_unit'} . 's'; 
    }
    
    if ($result != 1) {
        $matches->{'to_unit'} = (exists $plural_exceptions{$matches->{'to_unit'}}) ? $plural_exceptions{$matches->{'to_unit'}} : $matches->{'to_unit'} . 's'; 
    }

    return "$factor $matches->{'from_unit'} is " . sprintf("%.3f", $result) . " $matches->{'to_unit'}";
};



1;
