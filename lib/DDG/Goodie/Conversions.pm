package DDG::Goodie::Conversions;
# ABSTRACT: convert between various units of measurement

use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use Math::Round qw/nearest/;
use bignum;
use Scalar::Util qw/looks_like_number/;
use Data::Float qw/float_is_infinite float_is_nan/;

name                      'Conversions';
description               'convert between various units of measurement';
category                  'calculations';
topics                    'computing', 'math';
primary_example_queries   'convert 5 oz to grams';
secondary_example_queries '5 ounces to g', '0.5 nautical miles in km';
code_url                  'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Conversions.pm';
attribution                github  => ['https://github.com/elohmrow', 'https://github.com/mintsoft'],
                           email   => ['bradley@pvnp.us', 'bradley@pvnp.us'];

zci answer_type => 'conversions';
zci is_cached   => 1;

# build the keys:
# unit types available for conversion
my @types = @{get_units()};

my @units = ();

foreach my $type (@types) {
    push(@units, $type->{'unit'});
    push(@units, @{$type->{'aliases'}});
}

# build triggers based on available conversion units:
triggers any => @units;

# match longest possible key (some keys are sub-keys of other keys):
my $keys = join '|', reverse sort { length($a) <=> length($b) } @units;
my $question_prefix = qr/(?<prefix>convert|what (?:is|are|does)|how (?:much|many|long) (?:is|are)?|(?:number of))?/;

# guards and matches regex
my $factor_re = join('|', ('a', 'an', number_style_regex()));
my $guard = qr/^(?<question>$question_prefix)\s?(?<left_num>$factor_re*)\s?(?<left_unit>$keys)\s(?<connecting_word>in|to|into|(?:in to)|from)?\s?(?<right_num>$factor_re*)\s?(?:of\s)?(?<right_unit>$keys)[\?]?$/i;

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

my %singular_exceptions = reverse %plural_exceptions;

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
    if    ($from =~ /fahrenheit|f/i) { $factor = $factor;                           }
    elsif ($from =~ /celsius|c/i)    { $factor = ($factor * (9 / 5)) + 32;          }
    elsif ($from =~ /kelvin|k/i)     { $factor = (9 / 5) * ($factor - 273.15) + 32; }
    elsif ($from =~ /rankine|r/i)    { $factor = $factor - 459.67;                  }
    else                             { $factor = ($factor * (9 / 4)) + 32;          } 
    
    # convert fahrenheit $to:
    if    ($to   =~ /fahrenheit|f/i) { $factor = $factor;                           }
    elsif ($to   =~ /celsius|c/i)    { $factor = ($factor - 32) * (5 / 9);          }
    elsif ($to   =~ /kelvin|k/i)     { $factor = ($factor + 459.67) * (5 / 9);      }
    elsif ($to   =~ /rankine|r/i)    { $factor = $factor + 459.67;                  }
    else                             { $factor = ($factor - 32) * (4 / 9);          }

    return $factor;
}

sub get_matches {
    my $matches = shift;
    my @matches = @{$matches};

    $matches[0] =~ s/"/inches/; 
    $matches[0] =~ s/'/feet/; 
    $matches[1] =~ s/"/inches/; 
    $matches[1] =~ s/'/feet/;

    my @match_types = ();
    my @factors = ();
    my @units = ();
    my @can_be_negative = ();
    
    foreach my $match (@matches) {
        foreach my $type (@types) {
            if (lc $match eq $type->{'unit'} || grep { $_ eq lc $match } @{$type->{'aliases'}}) {
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

sub parse_number {
    my $in = shift;
    my $out = ($in =~ /^(-?\d*(?:\.?\d+))\^(-?\d*(?:\.?\d+))$/) ? $1**$2 : $in;
    return 0 + $out;
}

sub convert {
    my $conversion = shift;
    my $matches = get_matches([$conversion->{'from_unit'}, $conversion->{'to_unit'}]);  
   
    if (looks_like_number($conversion->{'factor'})) {
        # looks_like_number thinks 'Inf' and 'NaN' are numbers:
        return if float_is_infinite($conversion->{'factor'}) || float_is_nan($conversion->{'factor'});

        return if $conversion->{'factor'} < 0 && !($matches->{'can_be_negative_1'} && $matches->{'can_be_negative_2'}); 
    }
    else {
        # if it doesn't look like a number, and it contains a number (e.g., '6^2'):
        $conversion->{'factor'} = parse_number($conversion->{'factor'});

        #return if $conversion->{'factor'} =~ /[^\d]/;
    }
    
    return if $conversion->{'factor'} =~ /[[:alpha:]]/;

    # matches must be of the same type (e.g., can't convert mass to length):
    return if ($matches->{'type_1'} ne $matches->{'type_2'});

    # run the conversion:
    # temperatures don't have 1:1 conversions, so they get special treatment:
    if ($matches->{'type_1'} eq 'temperature') {
        $matches->{'result'} = convert_temperatures($matches->{'from_unit'}, $matches->{'to_unit'}, $conversion->{'factor'})
    }
    else {
        $matches->{'result'} = $conversion->{'factor'} * ($matches->{'factor_2'} / $matches->{'factor_1'});
    }

###
### while massaging output is left to the implementation, there are some cases
### where answers might seem nonsensical, based on the input precision.  
### for example, converting '10mg to tons' with a precision of '3' gives '10 milligrams is 0.000 tons'
### the code below is one way to handle such cases:
###
###        if ($result == 0 || length($result) > 2*$precision + 1) {
###            # '10 mg to tons'                 => [0] , [1.10231e-08]
###            # '10000 minutes in microseconds' => [600000000000]
###            # '2500kcal in tons of tnt'       => [66194.888]
###
###            if ($result == 0) {
###                # rounding error
###                $result = convert_temperatures($matches->{'from_unit'}, $matches->{'to_unit'}, $factor);
###            }
###
###            $f_result = (sprintf "%.${precision}g", $result);
###        }
###   
    return $matches;
};



sub wrap_html {
    my ($factor, $result, $styler) = @_;
    my $from = $styler->with_html($factor) . " <span class='text--secondary'>" . html_enc($result->{'from_unit'}) . "</span>";
    my $to = $styler->with_html($styler->for_display($result->{'result'})) . " <span class='text--secondary'>" . html_enc($result->{'to_unit'}) . "</span>";
    return "<div class='zci--conversions text--primary'>$from = $to</div>";
}

handle query_lc => sub {
    # hack around issues with feet and inches for now
    $_ =~ s/"/inches/;
    $_ =~ s/'/feet/;

    # hack support for "degrees" prefix on temperatures
    $_ =~ s/ degrees (celsius|fahrenheit)/ $1/;

    # guard the query from spurious matches
    return unless $_ =~ /$guard/;

    my @matches = ($+{'left_unit'}, $+{'right_unit'});
    return if ("" ne $+{'left_num'} && "" ne $+{'right_num'});
    my $factor = $+{'left_num'};

    # if the query is in the format <unit> in <num> <unit> we need to flip
    # also if it's like "how many cm in metre"; the "1" is implicitly metre so also flip
    # But if the second unit is plural, assume we want the the implicit one on the first
    # It's always ambiguous when they are both countless and plural, so shouldn't be too bad.
    if (
        "" ne $+{'right_num'}
        || (   "" eq $+{'left_num'}
            && "" eq $+{'right_num'}
            && $+{'question'} !~ qr/convert/i
            && !looks_plural($+{'right_unit'})))
    {
        $factor = $+{'right_num'};
        @matches = ($matches[1], $matches[0]);
    }
    $factor = 1 if ($factor =~ qr/^(a[n]?)?$/);

    # fix precision and rounding:
    my $precision = 3;
    my $nearest = '.' . ('0' x ($precision-1)) . '1';

    my $styler = number_style_for($factor);
    return unless $styler;

    my $result = convert( {
        'factor' => $styler->for_computation($factor),
        'from_unit' => $matches[0],
        'to_unit' => $matches[1],
        'precision' => $precision,
    } );

    return if !$result->{'result'};

    my $f_result;

    # if $result = 1.00000 .. 000n, where n <> 0 then $result != 1 and throws off pluralization, so:
    $result->{'result'} = nearest($nearest, $result->{'result'});

    if ($result->{'result'} == 0 || length($result->{'result'}) > 2*$precision + 1) {
        if ($result->{'result'} == 0) {
            # rounding error
            $result = convert( {
                'factor' => $styler->for_computation($factor),
                'from_unit' => $matches[0],
                'to_unit' => $matches[1],
                'precision' => $precision,
            } );
        }

        # We only display it in exponent form if it's above a certain number.
        # We also want to display numbers from 0 to 1 in exponent form.
        if($result->{'result'} > 1_000_000 || $result->{'result'} < 1) {
            $f_result = (sprintf "%.${precision}g", $result->{'result'});
        } else {
            $f_result = (sprintf "%.${precision}f", $result->{'result'});
        }
    }

    # handle pluralisation of units
    # however temperature is never plural and does require "degrees" to be prepended
    if ($result->{'type_1'} ne 'temperature') {
        $result->{'from_unit'} = set_unit_pluralisation($result->{'from_unit'}, $factor);
        $result->{'to_unit'}   = set_unit_pluralisation($result->{'to_unit'},   $result->{'result'});
    } else {
        $result->{'from_unit'} = "degrees $result->{'from_unit'}" if ($result->{'from_unit'} ne "kelvin");
        $result->{'to_unit'} = "degrees $result->{'to_unit'}" if ($result->{'to_unit'} ne "kelvin");
    }

    $result->{'result'} = defined($f_result) ? $f_result : sprintf("%.${precision}f", $result->{'result'});
    $result->{'result'} =~ s/\.0{$precision}$//;
    $result->{'result'} = $styler->for_display($result->{'result'});

    my $output = $styler->for_display($factor)." $result->{'from_unit'} = $result->{'result'} $result->{'to_unit'}";
    return $output, html => wrap_html($factor, $result, $styler);
};

sub set_unit_pluralisation {
    my ($unit, $count) = @_;
    my $proper_unit = $unit;    # By default, we'll leave it unchanged.

    my $already_plural = looks_plural($unit);

    if ($count == 1 && $already_plural) {
        $proper_unit = $singular_exceptions{$unit} || substr($unit, 0, -1);
    } elsif ($count != 1 && !$already_plural) {
        $proper_unit = $plural_exceptions{$unit} || $unit . 's';
    }

    return $proper_unit;
}

sub looks_plural {
    my $unit = shift;

    my @unit_letters = split //, $unit;
    return exists $singular_exceptions{$unit} || $unit_letters[-1] eq 's';
}

sub get_units {
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
            'factor'  => 1_000_000_000_000,
            'aliases' => ['mcg', 'micrograms', 'mcgs'],
            'type'    => 'mass',
        },
        {
            'unit'    => 'kilogram',
            'factor'  => 1000,
            'aliases' => ['kg', 'kilo', 'kilogramme', 'kilograms', 'kgs', 'kilos', 'kilogrammes'],
            'type'    => 'mass',
        },
        {
            'unit'    => 'gram',
            'factor'  => 1_000_000,
            'aliases' => ['g', 'gm', 'gramme', 'grams', 'gs', 'gms', 'grammes'],
            'type'    => 'mass',
        },
        {
            'unit'    => 'milligram',
            'factor'  => 1_000_000_000,
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
            'aliases'   => ['meters', 'metre', 'metres', 'm'],
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
            'factor'    => 1/1609.344,
            'aliases'   => ['miles', 'statute mile', 'statute miles', 'land mile', 'land miles'],
            'type'      => 'length',
        },
        {
            'unit'      => 'yard',
            'factor'    => '1.0936133',
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
            'unit'      => 'nanosecond',
            'factor'    => '86400000000000',
            'aliases'   => ['nanoseconds', 'nanosec', 'nanosecs', 'ns'],
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
        {    
            'unit'      => 'month',
            'factor'    => 12/365,
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
    
    # bit is base unit for digital
    # while not absolutely correct, a byte is defined as 8 bits herein.
    # known SI units and aliases / plurals
    my @digital = (
        {   
            'unit'            => 'bit',
            'factor'          => 1,           
            'aliases'         => ['bits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'kilobit',
            'factor'          => 1/1_000,           
            'aliases'         => ['kbit', 'kbits', 'kilobits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'megabit',
            'factor'          => 1/1_000_000,           
            'aliases'         => ['mbit', 'mbits', 'megabits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'gigabit',
            'factor'          => 1/1_000_000_000,           
            'aliases'         => ['gbit', 'gigabits', 'gbits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'terabit',
            'factor'          => 1/1_000_000_000_000,           
            'aliases'         => ['tbit', 'tbits', 'terabits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'petabit',
            'factor'          => 1/1_000_000_000_000_000,           
            'aliases'         => ['pbit', 'pbits', 'petabits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'exabit',
            'factor'          => 1/1_000_000_000_000_000_000,           
            'aliases'         => ['ebit', 'ebits', 'exabits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'zettabit',
            'factor'          => 1/1_000_000_000_000_000_000_000,           
            'aliases'         => ['zbit', 'zbits', 'zettabits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'yottabit',
            'factor'          => 1/1_000_000_000_000_000_000_000_000,           
            'aliases'         => ['ybit', 'ybits', 'yottabits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'kibibit',
            'factor'          => 1/1024,           
            'aliases'         => ['kibit', 'kibits', 'kibibits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'mebibit',
            'factor'          => 1/1024**2,           
            'aliases'         => ['mibit', 'mibits', 'mebibits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'gibibit',
            'factor'          => 1/1024**3,           
            'aliases'         => ['gibit', 'gibits', 'gibibits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'tebibit',
            'factor'          => 1/1024**4,           
            'aliases'         => ['tibit', 'tibits', 'tebibits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'pebibit',
            'factor'          => 1/1024**5,           
            'aliases'         => ['pibit', 'pibits', 'pebibits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'exbibit',
            'factor'          => 1/1024**6,           
            'aliases'         => ['eibit', 'eibits', 'exbibits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'zebibit',
            'factor'          => 1/1024**7,           
            'aliases'         => ['zibit', 'zibits', 'zebibits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'yobibit',
            'factor'          => 1/1024**8,           
            'aliases'         => ['yibit', 'yibits', 'yobibits'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'byte',
            'factor'          => 1/8,           
            'aliases'         => ['bytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'kilobyte',
            'factor'          => 1/8_000,           
            'aliases'         => ['kb', 'kbs', 'kilobytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'megabyte',
            'factor'          => 1/8_000_000,           
            'aliases'         => ['mb', 'mbs', 'megabytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'gigabyte',
            'factor'          => 1/8_000_000_000,           
            'aliases'         => ['gb', 'gbs', 'gigabytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'terabyte',
            'factor'          => 1/8_000_000_000_000,           
            'aliases'         => ['tb', 'tbs', 'terabytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'petabyte',
            'factor'          => 1/8_000_000_000_000_000,           
            'aliases'         => ['pb', 'pbs', 'petabytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'exabyte',
            'factor'          => 1/8_000_000_000_000_000_000,           
            'aliases'         => ['eb', 'ebs', 'exabytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'zettabyte',
            'factor'          => 1/8_000_000_000_000_000_000_000,           
            'aliases'         => ['zb', 'zbs', 'zettabytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'yottabyte',
            'factor'          => 1/8_000_000_000_000_000_000_000_000,           
            'aliases'         => ['yb', 'ybs', 'yottabytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'kibibyte',
            'factor'          => 1/8192,           
            'aliases'         => ['kib', 'kibs', 'kibibytes'],       # KB     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'mebibyte',
            'factor'          => 1/8388608,           
            'aliases'         => ['mib', 'mibs', 'mebibytes'],       # MB
            'type'            => 'digital',
        },
        {   
            'unit'            => 'gibibyte',
            'factor'          => 1/8589934592,                       # 1/8*1024**3 ...           
            'aliases'         => ['gib', 'gibs', 'gibibytes'],       # GB ...
            'type'            => 'digital',
        },
        {   
            'unit'            => 'tebibyte',
            'factor'          => 1/8796093022208,           
            'aliases'         => ['tib', 'tibs', 'tebibytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'pebibyte',
            'factor'          => 1/9007199254740992,                 # 1/8*1024**5 ...           
            'aliases'         => ['pib', 'pibs', 'pebibytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'exbibyte',
            'factor'          => 1/9.22337203685478e+18,           
            'aliases'         => ['eib', 'eibs', 'exbibytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'zebibyte',
            'factor'          => 1/9.44473296573929e+21,           
            'aliases'         => ['zib', 'zibs', 'zebibytes'],     
            'type'            => 'digital',
        },
        {   
            'unit'            => 'yobibyte',
            'factor'          => 1/9.67140655691703e+24,           
            'aliases'         => ['yib', 'yibs', 'yobibytes'],     
            'type'            => 'digital',
        },
    );
	
	# hectare is base unit for area
    my @area = (
        {
            'unit'      => 'hectare',
            'factor'    => 1,
            'aliases'   => ['hectares', 'ha'],
            'type'      => 'area',
        },
        {
            'unit'      => 'acre',
            'factor'    => 2.4710439,
            'aliases'   => ['acres'],
            'type'      => 'area',
        },
        {
            'unit'      => 'square meter',
            'factor'    => 10_000,
            'aliases'   => ['square meters', 'metre^2', 'meter^2', 'metres^2', 'meters^2', 'square metre', 'square metres', 'm^2', 'm²'],
            'type'      => 'area',
        },
        {
            'unit'      => 'square kilometer',
            'factor'    => 0.01,
            'aliases'   => ['square kilometers', 'square kilometre', 'square kilometres', 'km^2', 'km²'],
            'type'      => 'area',
        },
        {
            'unit'      => 'square centimeter',
            'factor'    => 100_000_000,
            'aliases'   => ['square centimeters', 'square centimetre', 'square centimetres', 'cm^2', 'cm²'],
            'type'      => 'area',
        },
        {
            'unit'      => 'square millimeter',
            'factor'    => 10_000_000_000,
            'aliases'   => ['square millimeters', 'square millimetre', 'square millimetres', 'mm^2', 'mm²'],
            'type'      => 'area',
        },
        {
            'unit'      => 'square mile',
            'factor'    => 1/258.99881,
            'aliases'   => ['square miles', 'square statute mile', 'square statute miles', 'square land mile', 'square land miles', 'miles^2', 'miles²'],
            'type'      => 'area',
        },
        {
            'unit'      => 'square yard',
            'factor'    => 11959.9,
            'aliases'   => ['square yards', 'yard^2', 'yard²', 'yards²', 'yards^2', 'yd^2', 'yd²', 'yrd^2', 'yrd²'],
            'type'      => 'area',
        },
        {
            'unit'      => 'square foot',
            'factor'    => 107639.1,
            'aliases'   => ['square feet', 'feet^2', 'feet²', 'foot^2', 'foot²', 'ft²', 'ft^2'],
            'type'      => 'area',
        },
        {
            'unit'      => 'square inch',
            'factor'    => 15500031,
            'aliases'   => ['square inches', 'inch^2','inches^2', 'squinch', 'in^2', 'in²'],
            'type'      => 'area',
        }
    );

	# litre is the base unit for volume
	my @volume = (
		{
            'unit'      => 'litre',
            'factor'    => 1,
            'aliases'   => ['liter', 'litres', 'liters', 'l', 'litter', 'litters'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'millilitre',
            'factor'    => 1000,
            'aliases'   => ['milliliter', 'millilitres', 'milliliters', 'ml'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'cubic metre',
            'factor'    => 1/1000,
            'aliases'   => ['metre^3', 'meter^3', 'metres^3', 'meters^3', 'm^3', 'm³'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'cubic centimetre',
            'factor'    => 1000,
            'aliases'   => ['centimetre^3', 'centimeter^3', 'centimetres^3', 'centimeters^3', 'cm^3', 'cm³'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'cubic millimetre',
            'factor'    => 1_000_000,
            'aliases'   => ['millimetre^3', 'millimeter^3', 'millimetres^3', 'millimeters^3', 'mm^3', 'mm³'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'liquid pint',
            'factor'    => 1000/473.176473,
            'aliases'   => ['liquid pints', 'us pints', 'us liquid pint', 'us liquid pints'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'dry pint',
            'factor'    => 1000/550.6104713575,
            'aliases'   => ['dry pints'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'imperial pint',
            'factor'    => 1000/568.26125,
            'aliases'   => ['pints', 'pint', 'imperial pints', 'uk pint', 'british pint', 'pts'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'imperial gallon',
            'factor'    => 1/4.54609,
            'aliases'   => ['imperial gallon', 'uk gallon', 'british gallon', 'british gallons', 'uk gallons'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'us gallon',
            'factor'    => 1/3.785411784,
            'aliases'   => ['fluid gallon', 'us fluid gallon',  'fluid gallons', 'us gallons', 'gallon', 'gallons'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'quart',
            'factor'    => 1/0.946352946,
            'aliases'   => ['liquid quart', 'us quart', 'us quarts', 'quarts', 'liquid quarts'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'imperial quart',
            'factor'    => 4*1000/568.26125,
            'aliases'   => ['imperial quarts', 'british quarts', 'british quart'],
            'type'      => 'volume',
        },
		{
            'unit'      => 'imperial fluid ounce',
            'factor'    => 16*1000/568.26125,
            'aliases'   => ['imperial fluid ounces', 'imperial fl oz', 'imperial fluid oz', ],
            'type'      => 'volume',
        },
		{
            'unit'      => 'us fluid ounce',
            'factor'    => 16*1000/473.176473,
            'aliases'   => ['us fluid ounces', 'us fl oz', 'fl oz', 'fl. oz', 'fluid oz'],
            'type'      => 'volume',
        },
	);
	
    # unit types available for conversion
    my @types = (@mass, @length, @area, @volume, @time, @pressure, @energy, @power, @angle, @force, @temperature, @digital);    
    
    return \@types;
}

1;
