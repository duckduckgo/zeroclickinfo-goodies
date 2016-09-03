package DDG::Goodie::CoffeeToWaterRatio;

# ABSTRACT: Either return a default drip coffee to water ratio (no weight entered)
# or return a volume of liquid proportional to the coffee weight entered

use DDG::Goodie;
use Math::Round;
with 'DDG::GoodieRole::NumberStyler';

zci answer_type => "coffee_to_water_ratio";
zci is_cached   => 1;

triggers startend => "coffee to water", "coffee to water ratio";

my $MAX_WEIGHT = 100_000;

my %wt = (
    'ounce' => {
        'fluid_units' => "fl. oz.",
        'precision' => 0.1,
        'ratio' => 16,
    },
    'gram' => {
        'fluid_units' => "ml",
        'precision' => 1,
        'ratio' => 16.6945,
    }
);

my %unit_alias = (
    'oz' => 'ounce',
    'ounces' => 'ounce',
    'g' => 'gram',
    'grams' => 'gram'
);

my @empty_answer = ("1 g to 16.7 ml (0.035 oz. to 0.56 fl. oz.)", 
    structured_answer => {
        data => {
            title    => '16.7 ml (0.56 fl. oz.)',
            subtitle => 'Coffee to water ratio per gram (0.035 ounces)',
        },
        templates => {
            group => 'text',
        },
    }
);

my $weight_re = number_style_regex();

handle remainder => sub {

    return @empty_answer unless $_;

    return unless my ($weight_ns) = $_ =~ qr/($weight_re)/;
    my $weight_styler = number_style_for($weight_ns);
    my $weight = $weight_styler->for_computation($weight_ns);
    my $weight_display = $weight_styler->for_display($weight);

    my ($unit) = $_ =~ /(ounce[s]?|gram[s]?|oz|g)/i;

    return unless defined $unit and defined $weight;
    return unless $weight > 0 && $weight <= $MAX_WEIGHT;

    my $lc_unit = lc($unit);
    $lc_unit = $unit_alias{$lc_unit} if defined $unit_alias{$lc_unit};

    return unless defined $wt{$lc_unit};

    my $conversion = nearest($wt{$lc_unit}{'precision'}, $weight * $wt{$lc_unit}{'ratio'});

    return "$conversion $wt{$lc_unit}{'fluid_units'} of water", structured_answer => {
        data => {
            title    => "$conversion $wt{$lc_unit}{'fluid_units'} of water",
            subtitle => 'Water calculation for coffee weight: ' . $weight_display . $unit,
        },
        templates => {
            group => 'text',
        },
    };


};

1;
