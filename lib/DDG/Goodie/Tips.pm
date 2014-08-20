package DDG::Goodie::Tips;
# ABSTRACT: calculate a tip on a bill

use DDG::Goodie;

triggers any => 'tip', 'tips', '%';

primary_example_queries '20% tip on $21.63';
secondary_example_queries '20 percent tip for a $20 bill';
description 'calculate a total including a percentage tip';
name 'Tips';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Tips.pm';
category 'calculations';
topics 'everyday';
attribution github => [ 'http://github.com/mattlehning', 'mattlehning' ];

handle query_lc => sub {
    return unless my ($p, $is_tip, $sign,$num) = $_ =~/^(\d{1,3})(?: ?%| percent) (?:(tip (?:on|for|of))|of)(?: an?)? ([\$\-]?)(\d+(\.?)(?(5)\d+))(?: bill)?$/;
    $p /= 100;
    my $t = $p*$num;
    my $tot;

    if ($is_tip) {
	$tot = $num + $t;
    }

    $t = sprintf "%.2f", $t;
    $tot = sprintf "%.2f", $tot if $tot;

    if ($tot) {
	zci answer_type => 'tip';
	return "Tip: \$$t; Total: \$$tot";
    }
    $t = $sign . $t;
    $tot = $sign . $tot if $tot;
    zci answer_type => 'percentage';
    return "$t is ".($p*100)." percent of $sign$num";
	
};

1;
