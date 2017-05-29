package DDG::Goodie::Tips;
# ABSTRACT: calculate a tip/tax on a bill or a general percentage

use strict;
use DDG::Goodie;
use DDG::Util::NumberStyler;

# Yes, 'of' is very generic, the guard should kick back false positives very quickly.
triggers any => 'tip', 'tips', 'of', 'tax';

zci answer_type => 'tip';
zci is_cached   => 1;

my $number_re = number_style_regex();

handle query_lc => sub {
    return unless (/^(?<p>$number_re)(?: ?%| percent) (?:(?<do_tip>(?<tax_or_tip>tip|tax) (?:on|for|of))|of)(?: an?)? (?<sign>[\$\-]?)(?<num>$number_re)(?: bill)?$/);
    
    my ($p, $num, $sign) = ($+{'p'}, $+{'num'}, $+{'sign'});
    my $style = number_style_for($p, $num);
    $p   = $style->for_computation($p) / 100;
    $num = $style->for_computation($num);
    my $t = $p * $num;
    
    if ($+{'do_tip'}) {
        my $subtotal = $style->for_display(sprintf "%.2f", $num);
        my $tax_or_tip = ucfirst($+{'tax_or_tip'});
        my $tax_or_tip_value = $style->for_display(sprintf "%.2f", $t);
        my $total = $style->for_display(sprintf "%.2f", $num + $t);
        
        my $tax_or_tip_answer = "Subtotal: \$$subtotal; $tax_or_tip: \$$tax_or_tip_value; Total: \$$total";
        return $tax_or_tip_answer,
            structured_answer => {
                data => {
                    title => "$tax_or_tip_answer",
                },
                templates => {
                    group => 'text'
                }
            };
    }

    $t = sprintf "%.2f", $t if ($sign eq '$');    # Maybe this makes cents.
    my $calculated_answer = $style->for_display($t);
    my $percentage = $style->for_display($p * 100);
    my $number = $style->for_display($num);
    my $percent_answer = "$sign$calculated_answer is $percentage% of $sign$number";
    
    return $percent_answer,
        structured_answer => {
            data => {
                title => "$percent_answer"
            },
            templates => {
                group => 'text'
            }
        };
};

1;
