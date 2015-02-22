package DDG::Goodie::CoffeeToWaterRatio;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use Math::Round;

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
attribution github => ["nickselpa", "Nick Selpa"],
            twitter => "nickselpa";

# Triggers
triggers startend => "coffee to water", "coffee to water ratio";

# Handle statement
handle remainder => sub {

	# optional - regex guard
	# return unless qr/^\w+/;

	# Goodie assumes only oz and g
	 
	my @imperialwt = ('ounce', 'oz');
    my @metricwt = ('gram', 'g');
    
    my $imperial_to_water = 16;            # 16 oz to each 1oz of coffee
    my $metric_to_water = 16.6945;         # 16.6945ml to each 1g of coffee
    
	my ($weight) = $_ =~ /([0-9]*\.?[0-9]+)/;
    my ($unit) = $_ =~ /([a-zA-Z]+)/;
    
    # Return metric and imperial ratio, using 1g as answer base, if only trigger is entered
    
    return "1 g to 16.7 ml (0.035 oz. to 0.56 fl. oz.)", structured_answer => {
        input     => undef,
        operation => 'Coffee to water ratio per gram (0.035 ounces)',
        result    => "16.7 ml (0.56 fl. oz.)",
    } unless $_;
    
    # Return nothing if only numbers or letters are accompanied with the trigger
    
    return unless defined $weight and defined $unit;
    
    # Check weight if it matches imperial weight and return structured answer if it does
    # There is refactoring that can happen here but I'm just trying to get this to a first draft

    # Returns fluid ounces of water for coffee weight in ounces.
    foreach my $u (@imperialwt) {
    
        my $search_string = quotemeta $u;
        
        if (lc($unit) =~ /^$search_string/) {
            
            my $conversion = nearest(.1, $weight * $imperial_to_water);
            return $conversion . " fl. oz. of water", structured_answer => {
                input     => [$weight . " " . $unit],
                operation => 'Water calculation for imperial coffee weight',
                result    => "$conversion fl. oz. of water",
            };
        
        };
    
    };
    
    # Returns milliliters of water for coffee weight in grams
    foreach my $u (@metricwt) {
    
        my $search_string = quotemeta $u;
        
        if (lc($unit) =~ /^$search_string/) {
            
            my $conversion = nearest(1, $weight * $metric_to_water);
            return $conversion . " ml of water", structured_answer => {
                input     => [$weight . " " . $unit],
                operation => 'Water calculation for metric coffee weight',
                result    => "$conversion ml of water",
            };
        
        };
    
    };
    
    # Catch-all safe return for all other invalid queries (no IA)
    
    return;
 
};

1;
