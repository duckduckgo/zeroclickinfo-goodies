package DDG::Goodie::Conversions;
# ABSTRACT: convert between various units of measurement

use DDG::Goodie;
use Scalar::Util qw/looks_like_number/;

###@todo
###    --  1 -- include more unit types
###             see: https://github.com/duckduckgo/zeroclickinfo-goodies/issues/318
###    --  2 -- think about special ways feet-inches can be written (2'-4", etc.)
###    --  3 -- would like to handle things like "6^2 g to oz"

# metric ton is base unit for mass
# known SI units and aliases / plurals
my @mass = (
    {
        'unit'    => 'metric ton',
        'factor'  => '1',
        'aliases' => ['metric ton', 'tonne', 't', 'mt', 'te', 'metric tons', 'tonnes', 'ts', 'mts', 'tes'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'ounce',
        'factor'  => '35274',
        'aliases' => ['ounce', 'oz', 'ounces', 'ozs'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'pound',
        'factor'  => '2204.62',
        'aliases' => ['pound', 'lb', 'lbm', 'pound mass', 'pounds', 'lbs', 'lbms', 'pounds mass'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'stone',
        'factor'  => '157.473',
        'aliases' => ['stone', 'st', 'stones', 'sts'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'long ton',
        'factor'  => '0.984207',
        'aliases' => ['long ton', 'weight ton', 'imperial ton', 'long tons', 'weight tons', 'imperial tons'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'microgram',
        'factor'  => '1000000000',
        'aliases' => ['microgram', 'mcg', 'micrograms', 'mcgs'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'kilogram',
        'factor'  => '1000',
        'aliases' => ['kilogram', 'kg', 'kilo', 'kilogramme', 'kilograms', 'kgs', 'kilos', 'kilogrammes'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'gram',
        'factor'  => '1000000',
        'aliases' => ['gram', 'g', 'gm', 'gramme', 'grams', 'gs', 'gms', 'grammes'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'milligram',
        'factor'  => '1000000000',
        'aliases' => ['milligram', 'mg', 'milligrams', 'mgs'],
        'type'    => 'mass',
    },
    {
        'unit'    => 'short ton',
        'factor'  => '1.10231',
        'aliases' => ['short ton', 'ton', 'short tons', 'tons'],
        'type'    => 'mass',
    },
);

# meter is the base unit for length
# known SI units and aliases / plurals
my @length = (
    {
        'unit'      => 'meter',
        'factor'    => '1',
        'aliases'   => ['meter', 'meters', 'metre', 'metres', 'm', 'ms'],
        'type'      => 'length',
    },
    {
        'unit'      => 'kilometer',
        'factor'    => '0.001',
        'aliases'   => ['kilometer', 'kilometers', 'kilometre', 'kilometres', 'km', 'kms', 'klick', 'klicks'],
        'type'      => 'length',
    },
    {
        'unit'      => 'centimeter',
        'factor'    => '100',
        'aliases'   => ['centimeter', 'centimeters', 'centimetre', 'centimetres', 'cm', 'cms'],
        'type'      => 'length',
    },
    {
        'unit'      => 'millimeter',
        'factor'    => '1000',
        'aliases'   => ['millimeter', 'millimeters', 'millimetre', 'millimetres', 'mm', 'mms'],
        'type'      => 'length',
    },
    {
        'unit'      => 'mile',
        'factor'    => '0.000621371',
        'aliases'   => ['mile', 'miles', 'statute mile', 'statute miles', 'land mile', 'land miles'],
        'type'      => 'length',
    },
    {
        'unit'      => 'yard',
        'factor'    => '1.09361',
        'aliases'   => ['yard', 'yards', 'yd', 'yds'],
        'type'      => 'length',
    },
    {
        'unit'      => 'foot',
        'factor'    => '3.28084',
        'aliases'   => ['foot', 'feet', 'ft', 'international foot', 'international feet', 'survey foot', 'survey feet'],
        'type'      => 'length',
    },
    {
        'unit'      => 'inch',
        'factor'    => '39.3701',
        'aliases'   => ['inch', 'inches', 'in', 'ins'],
        'type'      => 'length',
    },
    {
        'unit'      => 'nautical mile',
        'factor'    => '0.000539957',
        'aliases'   => ['nautical mile', 'nautical miles', 'n', 'ns', 'nm', 'nms', 'nmi', 'nmis'],
        'type'      => 'length',
    },
);

# build the keys:
my @types = (@mass, @length);    # unit types available for conversion
my @units = ();
foreach my $type (@types) {
    push(@units, @{$type->{'aliases'}});
}

# match longest possible key (some keys are sub-keys of other keys):
my $keys = join '|', reverse sort { length($a) <=> length($b) } @units;

# build triggers based on available conversion units:
triggers startend => @units;

name                      'Conversions';
description               'convert between various units of measurement';
category                  'calculations';
topics                    'computing', 'math';
primary_example_queries   'convert 5 oz to grams';
secondary_example_queries '5 ounces to g', 'metric ton stone', '0.5 nautical mile to klick';
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
            if (grep { $_ eq $match } @{$type->{'aliases'}}) {
                push(@match_types, $type->{'type'});
                push(@factors, $type->{'factor'});
            }
        }
    }

    return (\@match_types, \@factors);
}

handle query => sub {
    my @matches = ($_ =~ /\b($keys)\b/gi);
   
    return unless scalar @matches == 2; # conversion requires two triggers

    my ($match_types, $factors) = get_types_and_factors(\@matches);
    my @match_types = @{$match_types};
    my @factors = @{$factors};
    
    # matches must be of the same type (e.g., can't convert mass to length):
    return if ($match_types[0] ne $match_types[1]);

    # get factor:
    my @args = split(/\s+/, $_);
    my $factor = 1;
    foreach my $arg (@args) {
        return if $arg =~ /\D/;     # see @todo #3
        if (looks_like_number($arg)) {
            $factor = $arg unless $factor != 1;     # drop n > 1 #s

            if ($match_types[0] !~ /temperature|pressure/) { # for when temp/pressure added in future
                return if $factor < 0;  # negative weights, etc. seem impossible :)
            }
        }
    }
    
    # run the conversion:
    return "$factor $matches[0] is " . sprintf("%.3f", $factor * ($factors[1] / $factors[0])) . " $matches[1]";
};


1;
