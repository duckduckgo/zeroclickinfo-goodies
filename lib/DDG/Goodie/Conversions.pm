package DDG::Goodie::Conversions;
# ABSTRACT: Handles triggering and preprocessing for the Conversions IA

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

use Math::Round qw/nearest/;
use Math::SigFigs qw/:all/;
use utf8;
use YAML::XS 'LoadFile';
use List::Util qw(any);

zci answer_type => 'conversions';
zci is_cached   => 1;

use bignum;

##
## Handles the normal /with unit/ triggering
##

my @types = LoadFile(share('triggers.yml'));
my @safe_abbrevs = qw/cm mm kj lbs psi km mb gb btu yd yds ghz kg kgs/;
my %natlang_hash = %{ LoadFile(share('langTriggers.yml')) };
my @natlang_array = LoadFile(share('langTriggers.yml'));

my @units = ();
foreach my $type (@types) {
    push(@units, $type->{'unit'});
    push(@units, @{$type->{'aliases'}});
    push(@units, @{$type->{'symbols'}}) if $type->{'symbols'};
}

# build triggers based on available conversion units:
my @triggers = map { lc $_ } @units;

##
## Handles the natural language triggering
##

my @general_triggers = ();

foreach my $trigger (@natlang_array) {
    push @general_triggers, @{$trigger->{'misc'}};
}

# we don't want to expand on the misc triggers, so we'll ditch them here
delete $natlang_hash{'misc'};

my @natural_language_triggers;
my @expanded_triggers;
my @generics = (
    "calculator",
    "calc",
    "converter",
    "unit converter",
    "unit conversion",
    "conversion table",
    "conversion",
    "conversions" ,
    "convertisseur",
    "convertidor",
);

for my $trig (@triggers) {
    push @expanded_triggers, map { "$trig $_" } @generics;
}

# appends the above generics to the /values/ in the yml file
# unit -> unit converter, unit calculator, ...
for my $array (values %natlang_hash) {
    for my $val (@$array) {
        push @natural_language_triggers, map { "$val $_" } @generics;
    }
}

# appends the above generics to the /keys/ in the yml file
# length -> length converter, length calculator, ...
for my $key (keys %natlang_hash) {
    push @natural_language_triggers, map { "$key $_" } @generics;
}

##
## Declares the triggering scheme
##

triggers any => ( 
    @general_triggers,              # eg. conversion calculator, conversions
    @expanded_triggers,             # eg. cm calculator, grams converter
    @natural_language_triggers,     # eg. mass converter, volume calc
    @triggers                       # eg. grams, mils, ergs
);

# match longest possible key (some keys are sub-keys of other keys):
my $keys = join '|', map { quotemeta $_ } reverse sort { length($a) <=> length($b) } @units;
my $question_prefix = qr/(?<prefix>conver(?:t|sion)|calculate|what (?:is|are|does)|how (?:much|many|long) (?:is|are)?|(?:number of)|(?:how to convert)|(?:convert from))?/i;

# guards and matches regex
my $factor_re = join('|', ('a', 'an', number_style_regex()));

my $guard = qr/^
                (?<question>$question_prefix)\s?
                (?<left_num>$factor_re*|\d+\/\d+)\s?(?<left_unit>$keys)
                (?:\s
                    (?<connecting_word>in|(?:convert(?:ed)?)?\s?to|vs|is|convert|per|=(?:[\s\?]+)?|in\sto|(?:equals|is)?\show\smany|(?:equals?(?:\swhat(?:\sin)?)?|make)\sa?|\?\s?=|are\s(?:there)?\s?in\sa?|(?:is\swhat\sin)|(?:in to)|from)?\s?
                    (?<right_num>$factor_re*|\d+\/\d+)\s?(?:of\s)?(?<right_unit>$keys)\s?
                    (?:conver(?:sion|ter)|calculator|equals(?:\swhat)?)?[\?]?
                )?
               $
              /ix;

# for 'most' results, like 213.800 degrees fahrenheit, decimal places
# for small, but not scientific notation, significant figures
my $accuracy = 3;
my $scientific_notation_sig_figs = $accuracy + 3;
my $nearest = '.' . ('0' x ($accuracy-1)) . '1';

# For a number represented as XeY, returns 1 + Y
sub magnitude_order {
    my $number = shift;
    my $to_check = sprintf("%e", $number);
    $to_check =~ /\d++\.?\d++e\+?(?<mag>-?\d++)/i;
    return 1 + $+{mag};
}
my $maximum_input = 10**100;

# checks to see if input is natural language trigger
sub is_natural_language_trigger {
    my $input = shift;
    return any { $_ eq $input } @natural_language_triggers;
}

sub is_general_trigger {
    my $input = shift;
    return any { $_ eq $input } @general_triggers;
}

# checks the base of the query
# eg. velocity converter --> speed
sub get_base_information {
    my $input = shift;
    $input =~ s/calculator|converter|conversion\s?|\s//gi;

    foreach my $key (keys %natlang_hash) {
        return $key if $key eq $input;
        next unless exists $natlang_hash{$key};

        my @hash_kv = @{$natlang_hash{$key}};
        foreach my $value (@hash_kv) {
            return $key if $input eq $value;
        }
    }
    # if not assigned such as 'unit calculator' we'll default to length
    return 'length';
}

# EXPERIMENTAL
# If the user is located in the US, we'll show them US type units instead of Imperial
sub us_locale {
    my $unit = shift;

    my @q_triggers = qw/q quintal/;
    my @cup_triggers = qw/cup cups/;
    my @floz_triggers = ('fluid ounce', 'fluid ounces', 'fluid oz', 'fluid ozs', 'floz', 'fl oz', 'fl. oz', 'fl. ozs');
    my @gallon_triggers = qw/gal gals gallon gallons/;
    my @quart_triggers = qw/quart quarts qt qts/;
    my @tbsp_triggers = qw/tbsp tablespoon tablespoon/;
    my @tsp_triggers = qw/tsp teaspoon tea spoon/;

    $unit = 'usfluidounce' if grep(/^$unit$/, @floz_triggers);
    $unit = 'usgallon' if grep(/^$unit$/, @gallon_triggers);
    $unit = 'usquart' if grep(/^$unit$/, @quart_triggers);
    $unit = 'ustbsp' if grep(/^$unit$/, @tbsp_triggers);
    $unit = 'uscup' if grep(/^$unit$/, @cup_triggers);
    $unit = 'ustsp' if grep(/^$unit$/, @tsp_triggers);
    $unit = 'usquintal' if grep(/^$unit$/, @q_triggers);

    return $unit;
}

handle query => sub {

    # for natural language queries, settle with default template / data
    if (is_natural_language_trigger($_) || is_general_trigger($_)) {
        return '', structured_answer => {
            data => {
                physical_quantity => get_base_information($_)
            },
            templates => {
                group => 'base',
                options => {
                    content => 'DDH.conversions.content'
                }
            }
        };
    }

    my $generic_postfixes = join "|", @generics;
    my $preserved_query = $_;
    $_ =~ s/$generic_postfixes//;
    $_ =~ s/\s+$//;

    # hack around issues with feet and inches for now
    $_ =~ s/"/inch/;
    $_ =~ s/'/foot/;

    # hack around the dropped micro symbol
    $_ =~ s/μ/micro/;

    if($_ =~ /(\d+)\s*(?:feet|foot)\s*(\d+)(?:\s*inch(?:es)?)?/i){
        my $feetHack = $1 + $2/12;
        $_ =~ s/(\d+)\s*(?:feet|foot)\s*(\d+)(?:\s*inch(?:es)?)?/$feetHack feet/i;
    }

    # hack support for "degrees" prefix on temperatures
    $_ =~ s/ degree[s]? (centigrade|cel[sc]ius|fah?renheit|rankine)/ $1/i;

    # guard the query from spurious matches
    return unless $_ =~ /$guard/;

    my $left_unit = $+{'left_unit'};
    my $left_num = $+{'left_num'};
    my $right_unit = $+{'right_unit'} // "";
    my $right_num = $+{'right_num'} // "";
    my $question = $+{'question'} // "";
    my $connecting_word = $+{'connecting_word'} // "";

    # If the user is in the US, we'll show them US type units, else default to imperial
    $left_unit = us_locale($left_unit) if $loc->country_code eq 'US';
    $right_unit = us_locale($right_unit) if $loc->country_code eq 'US';

    my $factor = $left_num;
    my @matches = ($left_unit, $right_unit);

    # ignore conversion when both units have a number
    return if ($left_num && $right_num);
    return if (length $left_unit <= 3 && !grep(/^$preserved_query$/, @expanded_triggers) && !grep(/^$left_unit$/, @safe_abbrevs)) && !($left_num || $right_unit);
    
    # Compare factors of both units to ensure proper order when ambiguous
    # also, check the <connecting_word> of regex for possible user intentions
    my @factor1 = (); # conversion factors, not left_num or right_num values
    my @factor2 = ();

    # gets factors for comparison
    foreach my $type (@types) {
        if( lc $left_unit eq lc $type->{'unit'} || $type->{'symbols'} && grep {$_ eq $left_unit } @{$type->{'symbols'}}) {
            push(@factor1, $type->{'factor'});
        }

        my @aliases1 = @{$type->{'aliases'}};
        foreach my $alias1 (@aliases1) {
            if(lc $left_unit eq lc $alias1) {
                push(@factor1, $type->{'factor'});
            }
        }

        if(lc $right_unit eq lc $type->{'unit'} || $type->{'symbols'} && grep {$_ eq $right_unit } @{$type->{'symbols'}}) {
            push(@factor2, $type->{'factor'});
        }

        my @aliases2 = @{$type->{'aliases'}};
        foreach my $alias2 (@aliases2) {
            if(lc $right_unit eq lc $alias2) {
                push(@factor2, $type->{'factor'});
            }
        }
    }

    # handle case when there is no "to" unit
    # e.g. "36 meters"
    if ($left_unit && !($right_unit || $right_num)) {
        $factor = $left_num;
    }
    # if the query is in the format <unit> in <num> <unit> we need to flip
    # also if it's like "how many cm in metre"; the "1" is implicitly metre so also flip
    # But if the second unit is plural, assume we want the the implicit one on the first
    # It's always ambiguous when they are both countless and plural, so shouldn't be too bad.
    elsif (
        "" ne $right_num
        || (   "" eq $left_num
            && "" eq $right_num
            && $question !~ qr/convert/i
            && $connecting_word !~ qr/to|=/i ))
    {
        $factor = $right_num;
        @matches = reverse @matches;
    }

    $factor = 1 if ($factor =~ qr/^(a[n]?)?$/i);

    # if the factor is a faction, we will convert it to decimal and round to 3 sig figs
    if($factor =~ m|(\d+)/(\d+)|) {
        $factor = $1 / $2;
        $factor = nearest(".0001", $factor);
    }

    my $styler = number_style_for($factor);
    return unless $styler;
    return unless $styler->for_computation($factor) < $maximum_input;

    my $result = convert({
        'factor' => $styler->for_computation($factor),
        'from_unit' => $matches[0],
        'to_unit' => $matches[1],
    });

    return unless defined $result->{'from_unit'} && defined $result->{'type'};

    my $computable_factor = $styler->for_computation($factor);
    if (magnitude_order($computable_factor) > 2*$accuracy + 1) {
        $factor = sprintf('%g', $computable_factor);
    };
    $factor = $styler->for_display($factor);

    return "", structured_answer => {
        data => {
            raw_input         => $styler->for_computation($factor),
            left_unit         => $result->{'from_unit'},
            right_unit        => $result->{'to_unit'},
            physical_quantity => $result->{'type'}
        },
        templates => {
            group => 'base',
            options => {
                content => 'DDH.conversions.content'
            }
        }
    };
};

sub get_matches {
    my @input_matches = @_;
    my @output_matches = ();
    
    OUTER:
    foreach my $match (@input_matches) {
        foreach my $type (@types) {
            if ($type->{'symbols'} && grep { $_ eq $match } @{$type->{'symbols'}}) {
                push(@output_matches,{
                    type => $type->{'type'},
                    factor => $type->{'factor'},
                    unit => $type->{'unit'},
                    can_be_negative => $type->{'can_be_negative'} || '0'
                });
                next OUTER;
            } elsif(lc $match eq lc $type->{'unit'} || grep { $_ eq lc $match } @{$type->{'aliases'}}) {
                push(@output_matches,{
                    type => $type->{'type'},
                    factor => $type->{'factor'},
                    unit => $type->{'unit'},
                    can_be_negative => $type->{'can_be_negative'} || '0'
                });
            }

        }
    }

    return @output_matches;
}

sub convert {
    my ($conversion) = @_;
    my @inputs = ($conversion->{'from_unit'});
    push @inputs, $conversion->{'to_unit'} if defined $conversion->{'to_unit'};
    my @matches = get_matches(@inputs);
    return if scalar(@matches) < 1;
    return if $conversion->{'factor'} < 0 && !($matches[0]->{'can_be_negative'});

    # Handles the ambigous handling of the word 'degrees' in temperature conversions
    if($matches[0]->{'type'} eq 'angle' && $matches[1]->{'unit'} eq 'fahrenheit') {
        $matches[0]->{'unit'} = 'celsius';        
        $matches[0]->{'type'} = 'temperature';
    }
    elsif($matches[0]->{'unit'} eq 'fahrenheit' && $matches[1]->{'type'} eq 'angle')   {
        $matches[1]->{'unit'} = 'celsius';        
        $matches[1]->{'type'} = 'temperature';
    }

    if($matches[0]->{'type'} eq 'angle' && $matches[1]->{'unit'} eq 'celsius') {
        $matches[0]->{'unit'} = 'fahrenheit';
        $matches[0]->{'type'} = 'temperature';
    }
    elsif($matches[0]->{'unit'} eq 'celsius' && $matches[1]->{'type'} eq 'angle')  {
        $matches[1]->{'unit'} = 'fahrenheit';
        $matches[1]->{'type'} = 'temperature';
    }

    # Handles ounce (mass) / fl ounce (volume) ambiguity
    if(defined $matches[1]->{'unit'}) {
        if($matches[0]->{'unit'} eq 'ounce' || $matches[1]->{'unit'} eq 'ounce') {
            if ($matches[0]->{'type'} eq 'mass' && $matches[1]->{'type'} eq 'volume') {
                $matches[0]->{'unit'} = "impfluidounce" if $matches[0]->{'unit'} eq "ounce";
                $matches[0]->{'type'} = "volume";
            }
            elsif ($matches[1]->{'type'} eq 'mass' && $matches[0]->{'type'} eq 'volume') {
                $matches[1]->{'unit'} = "impfluidounce" if $matches[1]->{'unit'} eq "ounce";
                $matches[1]->{'type'} = "volume";
            }
        }
    }

    # matches must be of the same type (e.g., can't convert mass to length):
    return if (defined $matches[1]->{'type'} && (scalar(@matches) > 1 && $matches[0]->{'type'} ne $matches[1]->{'type'}));

    return {
        "from_unit" => $matches[0]->{'unit'},
        "to_unit" => $matches[1]->{'unit'} // "",
        "type"  => $matches[0]->{'type'}
    };
}

1;
