package DDG::Goodie::Conversions;
# ABSTRACT: convert between various weights and measures

use DDG::Goodie;
use Scalar::Util qw(looks_like_number);

# metric ton is base unit
# known SI units and aliases / plurals
my %units = (
    # metric ton:
    'metric ton'    => '1',
    'tonne'         => '1',
    't'             => '1',
    'mt'            => '1',
    'te'            => '1',
    'metric tons'   => '1',
    'tonnes'        => '1',
    'ts'            => '1',
    'mts'           => '1',
    'tes'           => '1',
    
    # kilogram:
    'kilogram'      => '1000',
    'kg'            => '1000',
    'kilo'          => '1000',
    'kilogramme'    => '1000',
    'kilograms'     => '1000',
    'kgs'           => '1000',
    'kilos'         => '1000',
    'kilogrammes'   => '1000',
     
    # gram:
    'gram'          => '1000000',
    'g'             => '1000000',
    'gm'            => '1000000',
    'gramme'        => '1000000',
    'grams'         => '1000000',
    'gs'            => '1000000',
    'gms'           => '1000000',
    'grammes'       => '1000000',
    
    # milligram:
    'milligram'     => '1000000000',
    'mg'            => '1000000000',
    'milligrams'    => '1000000000',
    'mgs'           => '1000000000',
    
    # microgram:
    'microgram'     => '1000000000',
    'mcg'           => '1000000000',
    'micrograms'    => '1000000000',
    'mcgs'          => '1000000000',
    
    # long ton:
    'long ton'      => '0.984207',
    'weight ton'    => '0.984207',
    'imperial ton'  => '0.984207',
    'long tons'     => '0.984207',
    'weight tons'   => '0.984207',
    'imperial tons' => '0.984207',
    
    # short ton:
    'short ton'     => '1.10231',
    'ton'           => '1.10231',
    'short tons'    => '1.10231',
    'tons'          => '1.10231',

    # stone:
    'stone'         => '157.473',
    'st'            => '157.473',
    'stones'        => '157.473',
    'sts'           => '157.473',
 
    # pound:
    'pound'         => '2204.62',
    'lb'            => '2204.62',
    'lbm'           => '2204.62',
    'pound mass'    => '2204.62',
    'pounds'        => '2204.62',
    'lbs'           => '2204.62',
    'lbms'          => '2204.62',
    'pounds mass'   => '2204.62',

    # ounce:
    'ounce'        => '35274',
    'oz'           => '35274',
    'ounces'       => '35274',
    'ozs'          => '35274',
);
    
# match longest possible key (some keys are sub-keys of other keys):
my $keys = join '|', reverse sort { length($a) <=> length($b) } keys %units;

# build triggers based on available conversion units:
triggers startend => keys %units;

name                      'Conversions';
description               'convert between various weights and measures';
category                  'calculations';
topics                    'computing', 'math';
primary_example_queries   'convert 5 oz to grams';
secondary_example_queries '5 ounces to g', 'metric ton stone';
code_url                  'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Conversions.pm';
attribution                github  => ['https://github.com/elohmrow', '/bda'],
                           email   => ['bradley@pvnp.us'];

zci answer_type => 'conversions';

handle query => sub {
    my @matches = ($_ =~ /\b($keys)\b/gi);
    
    return unless scalar @matches == 2; # conversion requires two triggers

    # get factor:
    my @args = split(/\s+/, $_);
    my $factor = 1;
    foreach my $arg (@args) {
        if (looks_like_number($arg)) {
            $factor = $arg unless $factor != 1;     # drop n > 1 #s

            return if $factor < 0;  # negative weights seem impossible :)
        }
    }
    
    # run the conversion:
    return "$factor $matches[0] is " . sprintf("%.3f", $factor * ($units{$matches[1]} / $units{$matches[0]})) . " $matches[1]";
};



1;
