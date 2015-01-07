package DDG::Goodie::Tips;
# ABSTRACT: calculate a tip on a bill

use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

# Yes, 'of' is very generic, the gaurd should kick back false positives very quickly.
triggers any => 'tip', 'tips', 'of';

primary_example_queries '20% tip on $21.63';
secondary_example_queries '20 percent tip for a $20 bill';
description 'calculate a total including a percentage tip';
name 'Tips';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Tips.pm';
category 'calculations';
topics 'everyday';
attribution github => [ 'mattlehning', 'Matt Lehning' ];

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
