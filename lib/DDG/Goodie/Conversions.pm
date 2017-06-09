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

my @types = LoadFile(share('triggers.yml'));

my @units = ();
foreach my $type (@types) {
    push(@units, $type->{'unit'});
    push(@units, @{$type->{'aliases'}});
    push(@units, @{$type->{'symbols'}}) if $type->{'symbols'};
}

# build triggers based on available conversion units:
my @triggers = map { lc $_ } @units;
triggers any => @triggers;

my @lang_triggers = share('langTriggers.txt')->slurp(chomp => 1);

triggers any => @lang_triggers;
my %lang_triggers = map { $_ => 1 } @lang_triggers;

# match longest possible key (some keys are sub-keys of other keys):
my $keys = join '|', map { quotemeta $_ } reverse sort { length($a) <=> length($b) } @units;
my $question_prefix = qr/(?<prefix>conver(?:t|sion)|what (?:is|are|does)|how (?:much|many|long) (?:is|are)?|(?:number of)|(?:how to convert)|(?:convert from))?/i;

# guards and matches regex
my $factor_re = join('|', ('a', 'an', number_style_regex()));

my $guard = qr/^(?<question>$question_prefix)\s?(?<left_num>$factor_re*)\s?(?<left_unit>$keys)\s((=\s?\?)|(equals|is)\s(how many )?)?(?<connecting_word>in|(?:convert(?:ed)?)?\s?to|vs|convert|per|=|into|(?:equals)? how many|(?:equal|make) a?|are in a|(?:is what in)|(?:in to)|from)?\s?(?<right_num>$factor_re*)\s?(?:of\s)?(?<right_unit>$keys)\s?(?:conver(?:sion|ter)|calculator)?[\?]?$/i;

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

handle query => sub {

    # for natural language queries, settle with default template / data
    if (exists($lang_triggers{$_}) && $_=~ m/(angle|area|(?:digital storage)|duration|energy|force|mass|power|pressure|temperature|volume)/) {
        return '', structured_answer => {
            data => {
                physical_quantity => $1
            },
            templates => {
                group => 'base',
                options => {
                    content => 'DDH.conversions.content'
                }
            }
        };
    }
    elsif(exists($lang_triggers{$_})) {
        return '', structured_answer => {
            data => {},
            templates => {
                group => 'base',
                options => {
                    content => 'DDH.conversions.content'
                }
            }
        };
    }

    # hack around issues with feet and inches for now
    $_ =~ s/"/inch/;
    $_ =~ s/'/foot/;

    if($_ =~ /(\d+)\s*(?:feet|foot)\s*(\d+)(?:\s*inch(?:es)?)?/i){
        my $feetHack = $1 + $2/12;
        $_ =~ s/(\d+)\s*(?:feet|foot)\s*(\d+)(?:\s*inch(?:es)?)?/$feetHack feet/i;
    }

    # hack support for "degrees" prefix on temperatures
    $_ =~ s/ degree[s]? (centigrade|celsius|fahrenheit|rankine)/ $1/i;

    # hack - convert "oz" to "fl oz" if "ml" contained in query
    s/(oz|ounces)/fl oz/i if(/(ml|cup[s]?|litre|liter|gallon|pint)/i && not /fl oz/i);

    # guard the query from spurious matches
    return unless $_ =~ /$guard/;

    my @matches = ($+{'left_unit'}, $+{'right_unit'});
    return if ("" ne $+{'left_num'} && "" ne $+{'right_num'});
    my $factor = $+{'left_num'};

    # Compare factors of both units to ensure proper order when ambiguous
    # also, check the <connecting_word> of regex for possible user intentions
    my @factor1 = (); # conversion factors, not left_num or right_num values
    my @factor2 = ();

    # gets factors for comparison
    foreach my $type (@types) {
        if( lc $+{'left_unit'} eq lc $type->{'unit'} || $type->{'symbols'} && grep {$_ eq $+{'left_unit'} } @{$type->{'symbols'}}) {
            push(@factor1, $type->{'factor'});
        }

        my @aliases1 = @{$type->{'aliases'}};
        foreach my $alias1 (@aliases1) {
            if(lc $+{'left_unit'} eq lc $alias1) {
                push(@factor1, $type->{'factor'});
            }
        }

        if(lc $+{'right_unit'} eq lc $type->{'unit'} || $type->{'symbols'} && grep {$_ eq $+{'right_unit'} } @{$type->{'symbols'}}) {
            push(@factor2, $type->{'factor'});
        }

        my @aliases2 = @{$type->{'aliases'}};
        foreach my $alias2 (@aliases2) {
            if(lc $+{'right_unit'} eq lc $alias2) {
                push(@factor2, $type->{'factor'});
            }
        }
    }

    # if the query is in the format <unit> in <num> <unit> we need to flip
    # also if it's like "how many cm in metre"; the "1" is implicitly metre so also flip
    # But if the second unit is plural, assume we want the the implicit one on the first
    # It's always ambiguous when they are both countless and plural, so shouldn't be too bad.
    if (
        "" ne $+{'right_num'}
        || (   "" eq $+{'left_num'}
            && "" eq $+{'right_num'}
            && $+{'question'} !~ qr/convert/i
            && $+{'connecting_word'} !~ qr/to/i ))
    {
        $factor = $+{'right_num'};
        @matches = ($matches[1], $matches[0]);
    }
    $factor = 1 if ($factor =~ qr/^(a[n]?)?$/i);

    my $styler = number_style_for($factor);
    return unless $styler;

    return unless $styler->for_computation($factor) < $maximum_input;

    my $result = convert({
        'factor' => $styler->for_computation($factor),
        'from_unit' => $matches[0],
        'to_unit' => $matches[1],
    });

    return unless defined $result->{'result'};

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
    foreach my $match (@input_matches) {
        foreach my $type (@types) {
            if (($type->{'symbols'} && grep { $_ eq $match } @{$type->{'symbols'}})
             || lc $match eq lc $type->{'unit'}
             || grep { $_ eq lc $match } @{$type->{'aliases'}} ) {
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

    my @matches = get_matches($conversion->{'from_unit'}, $conversion->{'to_unit'});
	return if scalar(@matches) != 2;
    return if $conversion->{'factor'} < 0 && !($matches[0]->{'can_be_negative'});

    # matches must be of the same type (e.g., can't convert mass to length):
    return if ($matches[0]->{'type'} ne $matches[1]->{'type'});

    return {
        "result" => "",
        "from_unit" => $matches[0]->{'unit'},
        "to_unit" => $matches[1]->{'unit'},
        "type"  => $matches[0]->{'type'}
    };
}

1;
