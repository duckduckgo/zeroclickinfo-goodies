package DDG::Goodie::Conversions;
# ABSTRACT: convert between various weights and measures

use DDG::Goodie;
use Scalar::Util qw(looks_like_number);
use Math::Round;

# metric ton is base unit
# known SI units and aliases
my %units = (
    # metric ton:
    'metric ton'   => '1',
    'tonne'        => '1',
    't'            => '1',
    'mt'           => '1',
    'te'           => '1',
    
    # kilogram:
    'kilogram'     => '1000',
    'kg'           => '1000',
    'kilo'         => '1000',
    'kilogramme'   => '1000',
     
    # gram:
    'gram'         => '1000000',
    'g'            => '1000000',
    'gm'           => '1000000',
    'gramme'       => '1000000',
    
    # milligram:
    'milligram'    => '1000000000',
    'mg'           => '1000000000',
    
    # microgram:
    'microgram'    => '1000000000',
    'mcg'          => '1000000000',
    
    # long ton:
    'long ton'     => '0.984207',
    'weight ton'   => '0.984207',
    'imperial ton' => '0.984207',
    
    # short ton:
    'short ton'    => '1.10231',
    'ton'          => '1.10231',

    # stone:
    'stone'        => '157.473',
    'st'           => '157.473',

    # pound:
    'pound'        => '2204.62',
    'lb'           => '2204.62',
    'lbm'          => '2204.62',
    'pound mass'   => '2204.62',

    # ounce:
    'ounce'        => '35274',
    'oz'           => '35274',
);

# build triggers based on available conversion units:
triggers startend => keys %units;

name                      'Conversions';
description               'convert between various weights and measures';
category                  'calculations';
topics                    'computing', 'math';
primary_example_queries   'convert 5 oz to grams';
secondary_example_queries '5 ounces to g';
code_url                  'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Conversions.pm';
attribution                github  => ['https://github.com/elohmrow', '/bda'],
                           email   => ['bradley@pvnp.us'];

zci answer_type => 'conversions';

handle query => sub {
    # match longest possible key (some keys are sub-keys of other keys):
    my $keys = join '|', reverse sort { length($a) <=> length($b) } keys %units;
    my @matches = ($_ =~ /\b($keys)s?\b/gi);
    
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
