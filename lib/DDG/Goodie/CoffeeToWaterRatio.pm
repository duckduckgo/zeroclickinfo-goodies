package DDG::Goodie::CoffeeToWaterRatio;

# ABSTRACT: Either return a default drip coffee to water ratio (no weight entered)
# or return a volume of liquid proportional to the coffee weight entered

use DDG::Goodie;
use Math::Round;
with 'DDG::GoodieRole::NumberStyler';

zci answer_type => "coffee_to_water_ratio";
zci is_cached   => 1;

triggers startend => "coffee to water", "coffee to water ratio";

my $imperial_fluid_units = 'fl. oz.';
my $metric_fluid_units = 'ml';

my $metric_precision =  1;
my $imperial_precision = 0.1;

my $imperial_to_water = 16;
my $metric_to_water = 16.6945;

my $MAX_WEIGHT = 100000; # limit to 100,000

my %wt = (
    'oz' => {
        'fluid_units' => $imperial_fluid_units,
        'precision' => $imperial_precision,
        'ratio' => $imperial_to_water,
    },
    'g' => {
        'fluid_units' => $metric_fluid_units,
        'precision' => $metric_precision,
        'ratio' => $metric_to_water,
    }
);

$wt{ounce} = $wt{oz};
$wt{ounces} = $wt{oz};
$wt{gram} = $wt{g};
$wt{grams} = $wt{g};

my $weight_re = number_style_regex();

sub convertResult {
    my ($unit, $weight, $weight_display, $water_ratio, $precision, $fluid_units) = @_;
    my $conversion = nearest($precision, $weight * $water_ratio);
    return $conversion . " " . $fluid_units . " of water", structured_answer => {
        input     => [$weight_display . $unit],
        operation => 'Water calculation for coffee weight',
        result    => "$conversion $fluid_units of water",
    };
}

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
    return unless $weight > 0 && $weight <= $MAX_WEIGHT;

    my $lc_unit = lc($unit);

    return convertResult($unit, $weight, $weight_display, $wt{$lc_unit}{'ratio'}, $wt{$lc_unit}{'precision'}, $wt{$lc_unit}{'fluid_units'}) if defined $wt{$lc_unit};

    return;

};

1;
