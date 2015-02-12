package DDG::Goodie::Conversions;
# ABSTRACT: convert between various units of measurement

use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use Math::Round qw/nearest/;
use bignum;
use Convert::Pluggable;

name                      'Conversions';
description               'convert between various units of measurement';
category                  'calculations';
topics                    'computing', 'math';
primary_example_queries   'convert 5 oz to grams';
secondary_example_queries '5 ounces to g', '0.5 nautical miles in km';
code_url                  'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Conversions.pm';
attribution                github  => 'https://github.com/elohmrow',
                           github => ['https://github.com/mintsoft', 'Rob Emery'],
                           email   => 'bradley@pvnp.us';

zci answer_type => 'conversions';
zci is_cached   => 1;

# build the keys:
# unit types available for conversion
my $c = new Convert::Pluggable();
my @types = @{$c->get_units()};

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

    my $result = $c->convert( {
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
            $result = $c->convert( {
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
        $result->{'from_unit'} = ($factor == 1 ? 'degree' : 'degrees') . ' ' . $result->{'from_unit'} if ($result->{'from_unit'} ne "kelvin");
        $result->{'to_unit'} = ($result->{'result'} == 1 ? 'degree' : 'degrees') . ' ' . $result->{'to_unit'} if ($result->{'to_unit'} ne "kelvin");
    }

    $result->{'result'} = defined($f_result) ? $f_result : sprintf("%.${precision}f", $result->{'result'});
    $result->{'result'} =~ s/\.0{$precision}$//;
    $result->{'result'} = $styler->for_display($result->{'result'});

    $factor = $styler->for_display($factor);

    return $factor . " $result->{'from_unit'} = $result->{'result'} $result->{'to_unit'}",
      structured_answer => {
        input     => [$styler->with_html($factor) . ' ' . $result->{'from_unit'}],
        operation => 'Convert',
        result    => $styler->with_html($result->{'result'}) . ' ' . $result->{'to_unit'},
      };
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

1;
