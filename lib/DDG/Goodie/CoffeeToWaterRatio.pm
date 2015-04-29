package DDG::Goodie::CoffeeToWaterRatio;
# ABSTRACT: Either return a default drip coffee to water ratio (no weight entered)
# or return a volume of liquid proportional to the coffee weight entered

use DDG::Goodie;
use Math::Round;
with 'DDG::GoodieRole::NumberStyler';

zci answer_type => "coffee_to_water_ratio";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "CoffeeToWaterRatio";
description "Finds the amount of water required for the weight of coffee used.";
primary_example_queries "29g coffee to water", "coffee to water ratio 1 ounce";
secondary_example_queries "29 grams coffee to water ratio";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
category "calculations";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
topics "food_and_drink";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CoffeeToWaterRatio.pm";
attribution github => ["nickselpa", "Nick Selpa"], twitter => "nickselpa";

# Triggers
triggers startend => "coffee to water", "coffee to water ratio";

my %imperialwt = (
    'ounce' => 'fl. oz.',
    'ounces' => 'fl. oz.',
    'oz' => 'fl. oz.',
);
    
my %metricwt = (
    'gram' => 'ml',
    'grams' => 'ml',
    'g' => 'ml',
);

my $weight_re = number_style_regex();

my $imperial_to_water = 16;   
my $metric_to_water = 16.6945;

sub convertResult {
    my ($unit, $weight, $weight_display, $water_ratio, $precision, $fluid_units) = @_;
    my $conversion = nearest($precision, $weight * $water_ratio);
    return $conversion . " " . $fluid_units . " of water", structured_answer => {
        input     => [$weight_display . $unit],
        operation => 'Water calculation for coffee weight',
        result    => "$conversion $fluid_units of water",
    };
}


# Handle statement
handle remainder => sub { 
        
    return "1 g to 16.7 ml (0.035 oz. to 0.56 fl. oz.)", structured_answer => {
        input     => [''],
        operation => 'Coffee to water ratio per gram (0.035 ounces)',
        result    => "16.7 ml (0.56 fl. oz.)",
    } unless $_;
    
    return unless my ($weight_ns) = $_ =~ qr/($weight_re)/;
    my $weight_styler = number_style_for($weight_ns);
    my $weight = $weight_styler->for_computation($weight_ns);
    my $weight_display = $weight_styler->for_display($weight);

    my ($unit) = $_ =~ /(ounce[s]?|gram[s]?|oz|g)/i;
    
    return unless defined $unit and defined $weight;
    
    return convertResult($unit, $weight, $weight_display, $metric_to_water, 1, $metricwt{lc($unit)}) if exists $metricwt{lc($unit)};
    return convertResult($unit, $weight, $weight_display, $imperial_to_water, .1, $imperialwt{lc($unit)}) if exists $imperialwt{lc($unit)};
            
    return;
 
};

1;
