package DDG::Goodie::Epoch;

use DDG::Goodie;
use Date::Calc qw(Today_and_Now Mktime);

zci is_cached => 1;
zci answer_type => "epoch";

triggers query_lc => qr/^epoch$/i;

handle query => sub {
    my ($year, $month, $day, $hour, $min, $sec) = Today_and_Now();
    my $epoch = Mktime($year, $month, $day, $hour, $min, $sec);
    $sec = '0' . $sec  if length($sec) == 1;
    $sec = '0' . $min  if length($min) == 1;
    $sec = '0' . $hour if length($hour) == 1;

    return qq(Unix time: $epoch (for $month/$day/$year $hour:$min:$sec));
};

1;