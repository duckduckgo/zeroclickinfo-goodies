package DDG::Goodie::Conversions;
# ABSTRACT: convert between various units of measurement

use DDG::Goodie;
use Data::Dump qw(dump);
use Scalar::Util qw/looks_like_number/;
use Data::Float qw/float_is_infinite float_is_nan/;

###@todo
###    --  1 -- include more unit types
###             see: https://github.com/duckduckgo/zeroclickinfo-goodies/issues/318
###    --  3 -- would like to handle things like "6^2 g to oz" (present undef;)

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
        'unit'    => 'short ton',
        'factor'  => '1.10231',
        'aliases' => ['ton', 'short tons', 'tons'],
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
        'factor'    => '86400000',
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

my @pressure = (
	{
		'unit'      => 'pascal',
		'factor'	=> 1,
		'aliases'   => ['pascals', 'pa', 'pas'],
		'type'		=> 'pressure',
	},
	{
		'unit'      => 'kilopascal',
		'factor'	=> (1/1000),
		'aliases'   => ['kilopascals', 'kpa', 'kpas'],
		'type'		=> 'pressure',
	},
	{
		'unit'      => 'megapascal',
		'factor'	=> (1/1_000_000),
		'aliases'   => ['megapascals', 'megapa', 'megapas'],
		'type'		=> 'pressure',
	},
	{
		'unit'      => 'gigapascal',
		'factor'	=> (1/1_000_000_000),
		'aliases'   => ['gigapascals', 'gpa', 'gpas'],
		'type'		=> 'pressure',
	},
	{
		'unit'      => 'bar',
		'factor'	=> 1/(100_000),
		'aliases'   => ['bars', 'pa', 'pas'],
		'type'		=> 'pressure',
	},
	{
		'unit'      => 'atmosphere',
		'factor'	=> 1/(101_325),
		'aliases'   => ['atmospheres', 'atm', 'atms'],
		'type'		=> 'pressure',
	},
	{
		'unit'      => 'psi',
		'factor'	=> 1/6894.8,
		'aliases'   => ['psis', 'pounds per square inch', 'lbs/inch^2', 'p.s.i.', 'p.s.i'],
		'type'		=> 'pressure',
	},
);

# build the keys:
my @types = (@mass, @length, @time, @pressure);    # unit types available for conversion
my @units = ();
foreach my $type (@types) {
    push(@units, $type->{'unit'});
    push(@units, @{$type->{'aliases'}});
}

# match longest possible key (some keys are sub-keys of other keys):
my $keys = join '|', reverse sort { length($a) <=> length($b) } @units;

# build triggers based on available conversion units:
triggers end => @units;

name                      'Conversions';
description               'convert between various units of measurement';
category                  'calculations';
topics                    'computing', 'math';
primary_example_queries   'convert 5 oz to grams';
secondary_example_queries '5 ounces to g', '0.5 nautical mile to klick';
code_url                  'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Conversions.pm';
attribution                github  => ['https://github.com/elohmrow', '/bda'],
                           email   => ['bradley@pvnp.us'];

zci answer_type => 'conversions';

#
#   helper function:
#       [1] get factors for later calculating conversion
#       [2] get trigger 'types' to determine if we can perform a calculation in the first place
#
sub get_types_and_factors {
    my $matches = shift;
    my @matches = @{$matches};

    my @match_types = ();
    my @factors = ();
    
    foreach my $match (@matches) {
        foreach my $type (@types) {
            if ($match eq $type->{'unit'} || grep { $_ eq $match } @{$type->{'aliases'}}) {
                push(@match_types, $type->{'type'});
                push(@factors, $type->{'factor'});
            }
        }
    }

    return (\@match_types, \@factors);
}

handle query => sub {
	# hack around issues with feet and inches for now
	s/"/inches/;
	s/'/feet/;
	
	# guard the query from spurious matches
	return unless /^(convert\s)?[0-9\.]+\s?($keys)\s?(in|to|from)\s?[0-9\.]*\s?($keys)+$/;
	
    my @matches = ($_ =~ /(?:[0-9]|\b)($keys)\b/gi);
    
   	# hack/handle the special case of "X in Y":
   	if ((scalar @matches == 3) && $matches[1] eq "in") {
   	    @matches = ($matches[0], $matches[2]);
  	}
    return unless scalar @matches == 2; # conversion requires two triggers

    my ($match_types, $factors) = get_types_and_factors(\@matches);
    my @match_types = @{$match_types};
    my @factors = @{$factors};

    # matches must be of the same type (e.g., can't convert mass to length):
    return if ($match_types[0] ne $match_types[1]);
	
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

            if ($match_types[0] !~ /temperature|pressure/) { # for when temp/pressure added in future
                return if $factor < 0;  # negative weights, etc. seem impossible :)
            }
        }
        else {
            # if it doesn't look like a number, and it contains a number (e.g., '6^2'):
            return if $arg =~ /\d/;
        }
    }

    # run the conversion:
    return "$factor $matches[0] is " . sprintf("%.3f", $factor * ($factors[1] / $factors[0])) . " $matches[1]";
};



1;