package DDG::Goodie::Conversions;
# ABSTRACT: convert between various weights and measures

# @todo: set significant digits
# @todo: handle multi-word units
# @todo: handle plural units

use DDG::Goodie;
use Scalar::Util qw(looks_like_number);

# known SI units and aliases / plurals / common uses:
my @units = (
        {
            'unit'          => 'metric ton',
            'multiple'      => '1',
            'aliases'       => ['tonne', 't', 'mt', 'te', 'metric'],
        },  
        { 
            'unit'          => 'kilogram',
            'multiple'      => '1000',  
            'aliases'       => ['kilo', 'kg', 'kilogramme', 'kilogram'],
        }, 
        {
            'unit'          => 'gram',                          # units
            'multiple'      => '1000000',                       # number of units in 1 metric ton
            'aliases'       => ['gram', 'g', 'gm', 'gramme'],   # alternate units
        },
        {
            'unit'          => 'milligram',
            'multiple'      => '1000000000',
            'aliases'       => ['milligram', 'mg'],
        },
        {
            'unit'          => 'microgram',
            'multiple'      => '1000000000000',
            'aliases'       => ['microgram', 'mcg'],
        },
        {
            'unit'          => 'long ton',
            'multiple'      => '0.984207',
            'aliases'       => ['long', 'weight', 'imperial'],
        },  
        {
            'unit'          => 'short ton', 
            'multiple'      => '1.10231',
            'aliases'       => ['ton',  'short'],
        },  
        {
            'unit'          => 'stone',
            'multiple'      => '157.473',
            'aliases'       => ['st', 'stone'],
        },
        {
            'unit'          => 'pound',
            'multiple'      => '2204.62',
            'aliases'       => ['lb', 'pound', 'lbm'], 
        }, 
        {
            'unit'          => 'ounce',
            'multiple'      => '35274',
            'aliases'       => ['ounce', 'oz'],
        },
);
# to limit math, convert entered unit to metric ton, then multiply factor
       
# build triggers based on available conversion units:
my @triggers = ();
foreach my $unit (@units) {
    push(@triggers, @{$unit->{'aliases'}});
}

triggers startend => @triggers;

name                      'Conversions';
description               'convert between various weights and measures';
category                  'calculations';
topics                    'computing', 'math';
primary_example_queries   'convert 5 oz to grams';
secondary_example_queries '5 ounces to g';
code_url                  'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Conversions.pm';
attribution                github  => ['https://github.com/elohmrow', '/bda'],
                           email   => ['bradley@pvnp.us'];

handle query => sub {
    my @args = split(/\s+/, $_);
    
    ###
    ###my %args = map { $_ => 1 } @args;
    ###@args{@args} = undef;
    ###my @matches = grep { exists $args{$_} } @triggers;
    ###
    ###return unless scalar @matches == 2;
    ###

    my @matches = ();
    my $factor = 1;
    foreach my $arg (@args) {
        if (lc($arg) ~~ @triggers) {
            push(@matches, lc($arg));
        }
        if (looks_like_number($arg)) {
            $factor = $arg;
        }
    }
    
    return unless scalar @matches == 2; # minimum conversion requires two @triggers

    # either pass over array again here, or %units must contain all aliases as keys.
    my $fromMultiple = 1;
    my $toMultiple = 1;
    foreach my $unit (@units) {
        if ($matches[0] ~~ @{$unit->{'aliases'}}) {
            $fromMultiple = $unit->{'multiple'}; 
        }
        if ($matches[1] ~~ @{$unit->{'aliases'}}) {
            $toMultiple = $unit->{'multiple'}; 
        }
    }

    # run the conversion:
    return "$factor $matches[0] is " . $factor * ($toMultiple / $fromMultiple) . " $matches[1]";
};



1;
