package DDG::Goodie::Conversions;
# ABSTRACT: convert between various units of measurement

use DDG::Goodie;
use Math::Round qw/nearest/;
use Scalar::Util qw/looks_like_number/;
use Convert::Pluggable 0.018;     
# ^^ mass, length, time, pressure, energy, power, angle, force, temperature, digital 

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

handle query_lc => sub {
    # hack around issues with feet and inches for now
    $_ =~ s/"/inches/;
    $_ =~ s/'/feet/;

    # guard the query from spurious matches
    return unless $_ =~ /$guard/;
    
    my @matches = ($_ =~ /$match_regex/gi);

    # hack/handle the special case of "X in Y":
    if ((scalar @matches == 3) && $matches[1] eq "in") {
        @matches = ($matches[0], $matches[2]);
    }
    return unless scalar @matches == 2; # conversion requires two triggers

    # normalize the whitespace, "25cm" should work for example
    $_ =~ s/([0-9])([a-zA-Z])/$1 $2/;

    # fix precision and rounding:
    my $precision = 3;
    my $nearest = '1';
    for my $i (1 .. $precision - 1) {
        $nearest = '0' . $nearest;
    }
    $nearest = '.' . $nearest;

    # get factor:
    my @args = split(/\s+/, $_);
    my $factor = 1;
    foreach my $arg (@args) {
        if (looks_like_number($arg)) {
            $factor = $arg unless $factor != 1;     # drop n > 1 #s
        }
    }
   
    my $result = $c->convert( { 'factor' => $factor, 'from_unit' => $matches[0], 'to_unit' => $matches[1], 'precision' => $precision, } );

    return if !$result->{'result'};

    my $f_result;

    # if $result = 1.00000 .. 000n, where n <> 0 then $result != 1 and throws off pluralization, so:
    $result->{'result'} = nearest($nearest, $result->{'result'});   
        
    if ($result->{'result'} == 0 || length($result->{'result'}) > 2*$precision + 1) {
        if ($result->{'result'} == 0) {
            # rounding error
            $result = $c->convert( { 'factor' => $factor, 'from_unit' => $matches[0], 'to_unit' => $matches[1], 'precision' => $precision, } );
        }

        $f_result = (sprintf "%.${precision}g", $result->{'result'});
    }

    if ($factor != 1 && $result->{'type_1'} ne 'temperature') {
        $result->{'from_unit'} = (exists $plural_exceptions{$result->{'from_unit'}}) ? $plural_exceptions{$result->{'from_unit'}} : $result->{'from_unit'} . 's'; 
    }
    
    if ($result->{'result'} != 1 && $result->{'type_1'} ne 'temperature') {
        $result->{'to_unit'} = (exists $plural_exceptions{$result->{'to_unit'}}) ? $plural_exceptions{$result->{'to_unit'}} : $result->{'to_unit'} . 's'; 
    }

    $result->{'result'} = defined($f_result) ? $f_result : sprintf("%.${precision}f", $result->{'result'});
    $result->{'result'} =~ s/\.0{$precision}$//;

    #my $temperature_label = ($result->{'type_1'} eq 'temperature') ? 'degrees' : '';
    if ($result->{'type_1'} eq 'temperature') {
        return "$factor degrees $result->{'from_unit'} is $result->{'result'} degrees $result->{'to_unit'}";
    }
    else {
        return "$factor $result->{'from_unit'} is $result->{'result'} $result->{'to_unit'}";
    }
};



1;
