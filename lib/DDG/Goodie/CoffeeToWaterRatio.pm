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

my @imperialwt = ('ounces', 'ounce', 'oz');
my @metricwt = ('grams', 'gram', 'g');
my $weight_re = number_style_regex();

my $imperial_to_water = 16;   
my $metric_to_water = 16.6945;

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

    my ($unit) = $_ =~ /([ouncezgramsOUNCEZGRAMS]+)/;
    
    return unless defined $unit and defined $weight;
    
    foreach my $u (@imperialwt) {
    
        my $search_string = quotemeta $u;
        
        if (lc($unit) =~ /^$search_string/) {
            
            my $conversion = nearest(.1, $weight * $imperial_to_water);
            my $weight_display = $weight_styler->for_display($weight);
            return $conversion . " fl. oz. of water", structured_answer => {
                input     => [$weight_display . $unit],
                operation => 'Water calculation for imperial coffee weight',
                result    => "$conversion fl. oz. of water",
            };
        
        };
    
    };
    
    foreach my $u (@metricwt) {
    
        my $search_string = quotemeta $u;
        
        if (lc($unit) =~ /^$search_string/) {
            
            my $conversion = nearest(1, $weight * $metric_to_water);
            my $weight_display = $weight_styler->for_display($weight);
            return $conversion . " ml of water", structured_answer => {
                input     => [$weight_display . $unit],
                operation => 'Water calculation for metric coffee weight',
                result    => "$conversion ml of water",
            };
        
        };
    
    };
    
    return;
 
};

1;
