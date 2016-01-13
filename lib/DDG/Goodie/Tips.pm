package DDG::Goodie::Tips;
# ABSTRACT: calculate a tip on a bill

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

# Yes, 'of' is very generic, the gaurd should kick back false positives very quickly.
triggers any => 'tip', 'tips', 'of';

zci answer_type => 'tip';
zci is_cached   => 1;

my $number_re = number_style_regex();

handle query_lc => sub {
    return unless (/^(?<p>$number_re)(?: ?%| percent) (?:(?<do_tip>tip (?:on|for|of))|of)(?: an?)? (?<sign>[\$\-]?)(?<num>$number_re)(?: bill)?$/);
    my ($p, $num, $sign) = ($+{'p'}, $+{'num'}, $+{'sign'});
    my $style = number_style_for($p, $num);
    $p   = $style->for_computation($p) / 100;
    $num = $style->for_computation($num);
    my $t = $p * $num;

    return 'Tip: $' . $style->for_display(sprintf "%.2f", $t) . '; Total: $' . $style->for_display(sprintf "%.2f", $num + $t) if ($+{'do_tip'});

    $t = sprintf "%.2f", $t if ($sign eq '$');    # Maybe this makes cents.
    return $sign . $style->for_display($t) . ' is ' . $style->for_display($p * 100) . ' percent of ' . $sign . $style->for_display($num);
};

1;
