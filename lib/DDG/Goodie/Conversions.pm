package DDG::Goodie::Conversions;
# ABSTRACT: convert between various units of measurement

use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use Math::Round qw/nearest/;
use bignum;
use Scalar::Util qw/looks_like_number/;
use Data::Float qw/float_is_infinite float_is_nan/;
use YAML qw(Load);

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

my @types = Load(scalar share('ratios.yml')->slurp);

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
sub looks_plural {
    my $unit = shift;

    my @unit_letters = split //, $unit;
    return exists $singular_exceptions{$unit} || $unit_letters[-1] eq 's';
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
    my $m = shift;
    my @matches = @{$m};

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
    return $matches;
};
sub wrap_html {
    my ($factor, $result, $styler) = @_;
    my $from = $styler->with_html($factor) . " <span class='text--secondary'>" . html_enc($result->{'from_unit'}) . "</span>";
    my $to = $styler->with_html($styler->for_display($result->{'result'})) . " <span class='text--secondary'>" . html_enc($result->{'to_unit'}) . "</span>";
    return "<div class='zci--conversions text--primary'>$from = $to</div>";
}
sub set_unit_pluralisation {
    my ($unit, $count) = @_;
    my $proper_unit = $unit;

    my $already_plural = looks_plural($unit);

    if ($count == 1 && $already_plural) {
        $proper_unit = $singular_exceptions{$unit} || substr($unit, 0, -1);
    } elsif ($count != 1 && !$already_plural) {
        $proper_unit = $plural_exceptions{$unit} || $unit . 's';
    }

    return $proper_unit;
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



1;