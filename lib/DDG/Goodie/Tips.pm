package DDG::Goodie::Tips;
# ABSTRACT: calculate a tip on a bill

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

# Yes, 'of' is very generic, the gaurd should kick back false positives very quickly.
triggers any => 'tip', 'tips', 'of';

zci answer_type => 'tip';
zci is_cached   => 1;


handle query_lc => sub {
    my $style = number_style_for($lang) or return;
    my $number_re = number_style_regex();
    return unless (/^(?<p>$number_re)(?: ?%| percent) (?:(?<do_tip>tip (?:on|for|of))|of)(?: an?)? (?<sign>[\$\-]?)(?<num>$number_re)(?: bill)?$/);
    my ($p, $num, $sign) = ($+{'p'}, $+{'num'}, $+{'sign'});
    $p   = $style->parse_number($p)->for_computation() / 100;
    $num = $style->parse_number($num)->for_computation();
    my $t = $p * $num;

    return 'Tip: ' .
        $style->parse_perl(sprintf "%.2f", $t)->for_currency() .
        '; Total: ' .
        $style->parse_perl(sprintf "%.2f", $num + $t)->for_currency()
        if ($+{'do_tip'});

    $t = sprintf "%.2f", $t if ($sign eq '$');    # Maybe this makes cents.
    return $style->parse_perl($t)->for_currency() .
        ' is ' .
        $style->parse_perl($p * 100)->for_display() .
        ' percent of ' .
        $style->parse_perl($num)->for_currency();
};

1;
