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
attribution                github  => ['https://github.com/elohmrow', 'https://github.com/mintsoft'],
                           email   => ['bradley@pvnp.us'];

zci answer_type => 'conversions';

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
triggers end => @units;

# match longest possible key (some keys are sub-keys of other keys):
my $keys = join '|', reverse sort { length($a) <=> length($b) } @units;
my $question_prefix = qr/(convert|what (is|are|does)|how (much|many|long) (is|are))?\s?/;

# guards and matches regex
my $number_re = number_style_regex();
my $guard = qr/^$question_prefix$number_re*\s?($keys)\s?(in|to|into|from)\s?$number_re*\s?($keys)$/;
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

# This function adds some HTML and styling to our output
# so that we can make it prettier.
my $css = share("style.css")->slurp;
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>$html";
}

sub wrap_html {
    my ($factor, $result, $styler) = @_;
    my $from = $styler->with_html($factor) . " <span class='text--secondary'>" . html_enc($result->{'from_unit'}) . "</span>";
    my $to = $styler->with_html($result->{'result'}) . " <span class='text--secondary'>" . html_enc($result->{'to_unit'}) . "</span>";
    return append_css("<div class='zci--conversions text--primary'>$from = $to</div>");
}

handle query_lc => sub {
    # hack around issues with feet and inches for now
    $_ =~ s/"/inches/;
    $_ =~ s/'/feet/;

    # hack support for "degrees" prefix on temperatures
    $_ =~ s/ degrees (celsius|fahrenheit)/ $1/;

    # guard the query from spurious matches
    return unless $_ =~ /$guard/;
    
    my @matches = ($_ =~ /$match_regex/gi);

    # hack/handle the special case of "X in Y":
    if ((scalar @matches == 3) && $matches[1] eq "in") {
        @matches = ($matches[0], $matches[2]);
    }
    return unless scalar @matches == 2; # conversion requires two triggers

    # normalize the whitespace, "25cm" should work for example
    $_ =~ s/($number_re)($keys)/$1 $2/g;

    # fix precision and rounding:
    my $precision = 3;
    my $nearest = '.' . ('0' x ($precision-1)) . '1';

    # get factor and return if multiple numbers are specified
    my @args = split(/\s+/, $_);
    my $factor = "";
    foreach my $arg (@args) {
        if ($arg =~ /^$number_re$/) {
            return if $factor;
            $factor = $arg;
        }
    }
    $factor = 1 if "" eq $factor;
    
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
        if ($factor != 1) {
            $result->{'from_unit'} = (exists $plural_exceptions{$result->{'from_unit'}}) ? $plural_exceptions{$result->{'from_unit'}} : $result->{'from_unit'} . 's'; 
        }
    
        if ($result->{'result'} != 1) {
            $result->{'to_unit'} = (exists $plural_exceptions{$result->{'to_unit'}}) ? $plural_exceptions{$result->{'to_unit'}} : $result->{'to_unit'} . 's'; 
        }
    }
    else {
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
