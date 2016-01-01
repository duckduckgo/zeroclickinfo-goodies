package DDG::Goodie::Conversions;
# ABSTRACT: convert between various units of measurement

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use Math::Round qw/nearest/;
use bignum;
use YAML qw(Load);

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

# fix precision and rounding:
my $precision = 3;
my $nearest = '.' . ('0' x ($precision-1)) . '1';

handle query_lc => sub {
    # hack around issues with feet and inches for now
    $_ =~ s/"/inches/;
    $_ =~ s/'/feet/;

    # hack support for "degrees" prefix on temperatures
    $_ =~ s/ degrees (celsius|fahrenheit)/ $1/;
    
    # hack - convert "oz" to "fl oz" if "ml" contained in query
    s/(oz|ounces)/fl oz/ if(/ml/ && not /fl oz/);
    
    # guard the query from spurious matches
    return unless $_ =~ /$guard/;
    
    my @matches = ($+{'left_unit'}, $+{'right_unit'});
    return if ("" ne $+{'left_num'} && "" ne $+{'right_num'});
    my $factor = $+{'left_num'};

    # Compare factors of both units to ensure proper order when ambiguous
    # also, check the <connecting_word> of regex for possible user intentions 
    my @factor1 = (); # conversion factors, not left_num or right_num values
    my @factor2 = ();
	    
    # gets factors for comparison
    foreach my $type (@types) {
        if($+{'left_unit'} eq $type->{'unit'}) {
            push(@factor1, $type->{'factor'});
        }
        
        my @aliases1 = @{$type->{'aliases'}};
        foreach my $alias1 (@aliases1) {
            if($+{'left_unit'} eq $alias1) {
                push(@factor1, $type->{'factor'});
            }
        }
        
        if($+{'right_unit'} eq $type->{'unit'}) {
            push(@factor2, $type->{'factor'});
        }
        
        my @aliases2 = @{$type->{'aliases'}};
        foreach my $alias2 (@aliases2) {
            if($+{'right_unit'} eq $alias2) {
                push(@factor2, $type->{'factor'});
            }
        }
    }


    # if the query is in the format <unit> in <num> <unit> we need to flip
    # also if it's like "how many cm in metre"; the "1" is implicitly metre so also flip
    # But if the second unit is plural, assume we want the the implicit one on the first
    # It's always ambiguous when they are both countless and plural, so shouldn't be too bad.
    if (
        "" ne $+{'right_num'}
        || (   "" eq $+{'left_num'}
            && "" eq $+{'right_num'}
            && $+{'question'} !~ qr/convert/i
            && !looks_plural($+{'right_unit'})
            && $+{'connecting_word'} !~ qr/to/i
            && $factor1[0] > $factor2[0]))
    {
        $factor = $+{'right_num'};
        @matches = ($matches[1], $matches[0]);
    }
    $factor = 1 if ($factor =~ qr/^(a[n]?)?$/);

    my $styler = number_style_for($factor);
    return unless $styler;

    my $result = convert({
        'factor' => $styler->for_computation($factor),
        'from_unit' => $matches[0],
        'to_unit' => $matches[1],
    });
    
    return if !$result->{'result'};

    my $formatted_result = sprintf("%.${precision}f", $result->{'result'});

    # if $result = 1.00000 .. 000n, where n <> 0 then $result != 1 and throws off pluralization, so:
    $result->{'result'} = nearest($nearest, $result->{'result'});

    if ($result->{'result'} == 0 || length($result->{'result'}) > 2*$precision + 1) {
        # rounding error
        $result = convert({
            'factor' => $styler->for_computation($factor),
            'from_unit' => $matches[0],
            'to_unit' => $matches[1],
        });

        # We only display it in exponent form if it's above a certain number.
        # We also want to display numbers from 0 to 1 in exponent form.
        if($result->{'result'} > 1_000_000 || abs($result->{'result'}) < 1) {
            $formatted_result = (sprintf "%.${precision}g", $result->{'result'});
        }
    }

    # handle pluralisation of units
    # however temperature is never plural and does require "degrees" to be prepended
    if ($result->{'type'} eq 'temperature') {
        $result->{'from_unit'} = ($factor == 1 ? "degree" : "degrees") . " $result->{'from_unit'}" if ($result->{'from_unit'} ne "kelvin");
        $result->{'to_unit'}   = ($result->{'result'} == 1 ? "degree" : "degrees") . " $result->{'to_unit'}" if ($result->{'to_unit'}   ne "kelvin");
    } else {
        $result->{'from_unit'} = set_unit_pluralisation($result->{'from_unit'}, $factor);
        $result->{'to_unit'}   = set_unit_pluralisation($result->{'to_unit'},   $result->{'result'});
    }

    $result->{'result'} = $formatted_result;
    $result->{'result'} =~ s/\.0{$precision}$//;
    $result->{'result'} = $styler->for_display($result->{'result'});

    $factor = $styler->for_display($factor);

    return $factor . " $result->{'from_unit'} = $result->{'result'} $result->{'to_unit'}",
      structured_answer => {
        input     => [$styler->with_html($factor) . ' ' . $result->{'from_unit'}],
        operation => 'convert',
        result    => $styler->with_html($result->{'result'}) . ' ' . $result->{'to_unit'},
      };
};

sub looks_plural {
    my ($unit) = @_;
    my @unit_letters = split //, $unit;
    return exists $singular_exceptions{$unit} || $unit_letters[-1] eq 's';
}
sub convert_temperatures {
    my ($from, $to, $factor) = @_;
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
    my @input_matches = @_;

    my @output_matches = ();
    foreach my $match (@input_matches) {
        foreach my $type (@types) {
            if (lc $match eq $type->{'unit'} || grep { $_ eq lc $match } @{$type->{'aliases'}}) {
                push(@output_matches,{
                    type => $type->{'type'},
                    factor => $type->{'factor'},
                    unit => $type->{'unit'},
                    can_be_negative => $type->{'can_be_negative'} || '0'
                });
            }
        }
    }
    return if scalar(@output_matches) != 2;
    return @output_matches;
}
sub convert {
    my ($conversion) = @_;
    my @matches = get_matches($conversion->{'from_unit'}, $conversion->{'to_unit'});
    
    return if $conversion->{'factor'} < 0 && !($matches[0]->{'can_be_negative'} && $matches[1]->{'can_be_negative'}); 
    # matches must be of the same type (e.g., can't convert mass to length):
    return if ($matches[0]->{'type'} ne $matches[1]->{'type'});

    my $result;
    # run the conversion:
    # temperatures don't have 1:1 conversions, so they get special treatment:
    if ($matches[0]->{'type'} eq 'temperature') {
        $result = convert_temperatures($matches[0]->{'unit'}, $matches[1]->{'unit'}, $conversion->{'factor'})
    }
    else {
        $result = $conversion->{'factor'} * ($matches[1]->{'factor'} / $matches[0]->{'factor'});
    }
    return {
        "result" => $result,
        "from_unit" => $matches[0]->{'unit'},
        "to_unit" => $matches[1]->{'unit'},
        "type"  => $matches[0]->{'type'}
    };
}
sub set_unit_pluralisation {
    my ($unit, $count) = @_;
    my $proper_unit = $unit;

    my $already_plural = looks_plural($unit);

    if ($already_plural && $count == 1) {
        $proper_unit = $singular_exceptions{$unit} || substr($unit, 0, -1);
    } elsif (!$already_plural && $count != 1) {
        $proper_unit = $plural_exceptions{$unit} || $unit . 's';
    }

    return $proper_unit;
}

1;