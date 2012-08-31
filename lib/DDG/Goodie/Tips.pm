package DDG::Goodie::Tips;
use DDG::Goodie;

triggers query_lc => qr/^(\d{1,3})(?: ?%| percent) (?:(tip (?:on|for))|of) ([\$\-]?)(\d+(\.?)(?(5)\d+))$/i;

handle matches => sub {
    my ($p, $is_tip, $sign,$num) = @_;
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
	return "Tip: \$$t  Total: \$$tot";
    }
    $t = $sign . $t;
    $tot = $sign . $tot if $tot;
    zci answer_type => 'percentage';
    return "$t is ".($p*100)." percent of $sign$num";
	
};

1;
