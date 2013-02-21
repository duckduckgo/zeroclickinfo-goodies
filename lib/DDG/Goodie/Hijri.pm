package DDG::Goodie::Hijri;

use DDG::Goodie;
use Date::Hijri;

zci answer_type => "date";

triggers any => 'hijri', 'gregorian';

handle query_lc => sub {

	return unless my ($gd, $gm, $gy, $gh) = $_ =~ /^(?:convert)?\s*(\d{0,2})(?:\/|\,)(\d{0,2})(?:\/|\,)(\d{3,4})\s*(?:to|in)\s*(hijri|gregorian)?\s*(?:years|date?)?$/;
	last if($gd>31);
	last if($gm>12);
	my $hd;
	my $hm;
	my $hy;
	($hd, $hm, $hy) = g2h($gd, $gm, $gy) if ($gh eq 'hijri');
	($hd, $hm, $hy) = h2g($gd, $gm, $gy) if ($gh eq 'gregorian');
	return $hd . '/' . $hm . '/' . $hy;

};
1;
