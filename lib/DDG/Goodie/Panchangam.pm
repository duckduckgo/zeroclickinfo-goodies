package DDG::Goodie::Panchangam;
# ABSTRACT: Return the Vedic / Hindu Calendar (Panchangam) for a particular day (default is today).

use DDG::Goodie;
use DateTime;
use Date::Indian;
use Time::ParseDate;
use utf8;

triggers startend => [
  'panchangam',
  'panjangam',
  'panjanga',
  'pancanga',
  'panchanga',
  'panchaanga',
  'panchānga',
  'panjika',
  'hindu calendar',
  'vedic calendar',
  'hindu almanac',
  'vedic almanac'
];

name 'Vedic / Hindu Calendar (Panchangam)';
description 'Return the Vedic / Hindu Calendar (Panchangam) for a particular day (default is today)';
primary_example_queries 'panchangam today';
secondary_example_queries 'panchangam tomorrow', 'next week panchangam', 'panchangam 2012-12-12', 'panchangam 01/12/2014';
category 'dates';
topics 'special_interest', 'everyday';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Panchangam.pm';
attribution github => ['http://github.com/kmg', 'kmg'];

my $tithiid = [
  'Shukla Pratipada (Waxing Moon - 1st Day)',
  'Shukla Dvitiya (Waxing Moon - 2nd Day)',
  'Shukla Tritiya (Waxing Moon - 3rd Day)',
  'Shukla Chaturthi (Waxing Moon - 4th Day)',
  'Shukla Panchami (Waxing Moon - 5th Day)',
  'Shukla Shashti (Waxing Moon - 6th Day)',
  'Shukla Saptami (Waxing Moon - 7th Day)',
  'Shukla Ashtami (Waxing Moon - 8th Day)',
  'Shukla Navami (Waxing Moon - 9th Day)',
  'Shukla Dashami (Waxing Moon - 10th Day)',
  'Shukla Ekadashi (Waxing Moon - 11th Day)',
  'Shukla Dvadashi (Waxing Moon - 12th Day)',
  'Shukla Trayodashi (Waxing Moon - 13th Day)',
  'Shukla Chaturdashi (Waxing Moon - 14th Day)',
  'Purnima (Full Moon - 15th Day)',
  'Krishna Pratipada (Waning Moon - 1st Day)',
  'Krishna Dvitiya (Waning Moon - 2nd Day)',
  'Krishna Tritiya (Waning Moon - 3rd Day)',
  'Krishna Chaturthi (Waning Moon - 4th Day)',
  'Krishna Panchami (Waning Moon - 5th Day)',
  'Krishna Shashti (Waning Moon - 6th Day)',
  'Krishna Saptami (Waning Moon - 7th Day)',
  'Krishna Ashtami (Waning Moon - 8th Day)',
  'Krishna Navami (Waning Moon - 9th Day)',
  'Krishna Dashami (Waning Moon - 10th Day)',
  'Krishna Ekadashi (Waning Moon - 11th Day)',
  'Krishna Dvadashi (Waning Moon - 12th Day)',
  'Krishna Trayodashi (Waning Moon - 13th Day)',
  'Krishna Chaturdashi (Waning Moon - 14th Day)',
  'Amavasya (New Moon - 15th Day)'
];

my $nkid = [
 'Ashvini (Horse-owner)',
 'Bharani (Bearer)',
 'Krittika (Cutter)',
 'Rohini (Growing or Red)',
 'Mrigashirsha (Deer\'s Head)',
 'Ardra (Moist)',
 'Punarvasu (Prosperity)',
 'Pushya (Flower)',
 'Ashlesha (Embrace)',
 'Magha (Mighty)',
 'Purva Phalghuni (Former Red One)',
 'Uttara Phalghuni (Latter Red One)',
 'Hasta (Hand)',
 'Chitra (Bright)',
 'Swati (Independent)',
 'Vishakha (Branched/Forked)',
 'Anuradha (Following Radha)',
 'Jyeshta (Eldest)',
 'Mula (Root)',
 'Purva Ashadha (Former Victor)',
 'Uttara Ashadha (Latter Victor)',
 'Shravana (Ear)',
 'Dhanishtha (Abundance)',
 'Shatabhisha (100 Physicians)',
 'Purva Bhadrapada (Front Good Feet)',
 'Uttara Bhadrapada (Back Good Feet)',
 'Revati (Rich)'
];

my $yogaid = [
  'Vishkambha (Supported)',
  'Priti (Fondness)',
  'Ayushman (Long-lived)',
  'Saubhagya (Good Fortune)',
  'Shobhana (Splendor)',
  'Atiganda (Large-cheeked)',
  'Sukarma (Virtuous)',
  'Dhriti (Determination)',
  'Shula (Spear, Pain)',
  'Ganda (Cheek)',
  'Vriddhi (Growth)',
  'Dhruva (Constant)',
  'Vyaghata (Beating)',
  'Harshana (Thrilling)',
  'Vajra (Diamond, Thunderbolt)',
  'Siddhi (Success)',
  'Vyatipata (Calamity)',
  'Variyana (Comfort)',
  'Parigha (Obstruction)',
  'Shiva (Auspicious)',
  'Siddha (Accomplished)',
  'Sadhya (Amenable)',
  'Shubha (Auspicious)',
  'Shukla (Bright White)',
  'Brahma (Priest, God)',
  'Indra (Chief)',
  'Vaidhriti (Poor Support)'
];

my $karanaid = [ qw(
  Bava Balava Kaulava Taitila Gara Vanija
  Vishti/Bhadra Shakuni Chatushpada Naga Kinstughna
)];

# all calculations - hms, get_tithi, get_nakshatra, get_yoga, get_karana, get_varjya etc
# inspired from https://metacpan.org/source/SYAMAL/Date-Indian-0.01/demo/example.pl

# Return hh:mm form string for the number.
sub hms {
  my ($arg) = @_;
  my $sign = '';
  $sign = '-' if $arg < 0;
  $arg *= -1 if $arg < 0;
  my $h = int($arg);
  my $m = int(($arg - $h)*60.0);
  my $s = int($arg*3600.0)%60;
  $m += 1 if $s >= 30;
  if ($m == 60){
    $m = 0;
    $h += 1;
  }
  $h = '0'.$h if $h < 10;
  $m = '0'.$m if $m < 10;
  return $sign.$h . ':' . $m;
}

# Get tithi's with ending for a particular day
# multiple tithi's can encompass a 24-hour day
sub get_tithi {
  my ($d) = @_;
  my %th = $d->tithi_endings();
  my @tithi_arr;
  for my $t (sort keys %th) {
    push @tithi_arr, $tithiid->[$t] . " ends at " . hms($th{$t});
  }
  my $tithi = join ', ', @tithi_arr;
  return $tithi;
}

# Get nakshatra's (constellations) with ending for a particular day
# multiple nakshatra's can encompass a 24-hour day
sub get_nakshatra {
  my ($d) = @_;
  my %nk = $d->nakshyatra_endings();
  my @nakshatra_arr;
  for my $t (sort keys %nk) {
    if ($nk{$t} > 0 && $nk{$t} <= 24.0) {
     push @nakshatra_arr, $nkid->[$t] . " ends at " . hms($nk{$t});
    }
  }
  my $nakshatra = join ', ', @nakshatra_arr;
  return $nakshatra;
}

# get the yoga (Soli-Lunar yoga) with endings for a particular day
# multiple yoga's can encompass a 24-hour day
sub get_yoga {
  my ($d) = @_;
  my %ye = $d->yoga_endings();
  my @yoga_arr;
  for my $y (sort keys %ye){
    push @yoga_arr, $yogaid->[$y] . " ends at " . hms($ye{$y});
  }
  my $yoga = join ', ', @yoga_arr;
  return $yoga;
}

# get the karana's (two divisions of a lunar day - tithi) with endings for a particular day
# two karana's encompass a lunar day (tithi)
sub get_karana {
  my ($d) = @_;
  my %ke = $d->karana_endings();
  my @karana_arr;
  for my $t (sort keys %ke){
    my $k;
    $k = 10 if $t == 0;
    $k = $t - 50 if $t >= 57;
    $k = ($t-1) % 7 if ($t >0) & ($t <57);
    push @karana_arr, $karanaid->[$k] . " ends at " . hms($ke{$t});
  }
  my $karana = join ', ', @karana_arr;
  return $karana;
}

# get the varjya (a stage in each lunar mansion during which no business should be begun)
# multiple varjya can encompass for a tithi
sub get_varjya {
  my ($d) = @_;
  my @vj = $d->varjyam();
  my @vj_arr;
  foreach my $vs ( @vj ){
    push @vj_arr, hms($vs) . " to " . hms($vs+1.6);
  }
  my $varjyam = join ', ', @vj_arr;
  return $varjyam;
}

handle remainder => sub {
  # Figure out requested date using parsedate 
  # or use today's date based on $loc->time_zone
  # or use today's date based on UTC
  my $dt;
  my $remaining = $_;
  $remaining =~ s/^\s+//;
  $remaining =~ s/\s+$//;
    # strip on, for, in words & empty spaces in front & back to aid parsedate
  s/^\s+//;
  s/\s+$//;
  s/^(?:on|for|in)\s+//;
  # parsedate runs on UK mode,ie dates of the dd/mm/yyyy
  # since this instant answer is targeted towards the 
  # Indian demographic who use this format
  # best would be that everyone uses yyyy-mm-dd, but one can wish right :)
  my ($parsedt, $rest) = parsedate($_, UK => 1, ZONE => 'UTC');
  # dont trigger if we cant parse a date and there is some other query
  if (!$parsedt && $remaining) {
    return;
  }
  if ($parsedt) {
    $dt = DateTime->from_epoch(epoch => $parsedt, time_zone => 'UTC');
  } elsif ($loc && $loc->time_zone) {
    $dt = DateTime->now(time_zone => $loc->time_zone);
  } else {
    $dt = DateTime->now(time_zone => 'UTC');
  }
  # calculate previous and next day dates in the format yyyy-mm-dd for
  # previous and next day links at the bottom of the info displayed
  my $prev_day = $dt->clone();
  $prev_day = $prev_day->subtract(days => 1)->ymd;
  my $next_day = $dt->clone();
  $next_day = $next_day->add(days => 1)->ymd;
  # date format for title display in instant answer
  my $display_day = $dt->strftime("%d %B %Y (%A)");

  # location set to Chennai, India and time zone set to IST for panchangam calculations
  my $location = '80.27E 13.05N';
  my $tz = '+05:30';
  my $ymd = $dt->ymd;
  my $d = Date::Indian->new(ymd=>    $ymd,
                            tz =>    $tz,
                            locn =>  $location
                          );

  # Tithi (Lunar day)
  my $tithi = get_tithi($d);

  # Nakshatra (Lunar constellation)
  my $nakshatra = get_nakshatra($d);

  # Yoga (Soli-Lunar Yoga)
  my $yoga = get_yoga($d);

  # Karana (Two divisions of a lunar day)
  my $karana = get_karana($d);

  # Rahu kalam (inauspicious time)
  my ($rk_from, $rk_to) = $d->rahu_kalam();
  my $rahu_kalam = hms($rk_from) . " to " . hms($rk_to);

  # Gulika kalam
  my ($gk_from, $gk_to) = $d->gulika_kalam();
  my $gulika_kalam = hms($gk_from) . " to " . hms($gk_to);

  # Yamaganda kalam (inauspicious time)
  my ($yk_from, $yk_to) = $d->yamaganda_kalam();
  my $yamaganda_kalam = hms($yk_from) . " to " . hms($yk_to);

  # Durmuhurtas. (inauspicious time)
  my ($d1_s, $d1_e, $d2_s, $d2_e) = $d->durmuhurtam();
  my $durmuhurtam = hms($d1_s) . " to " . hms($d1_e);
  if ($d2_s) {
    $durmuhurtam .= ', ' . hms($d2_s) . " to " . hms($d2_e);
  }

  # Varjyam. (inauspicious time)
  my $varjyam = get_varjya($d);

  # Sunrise, Sunset on which above calculations are based
  my ($sunrise, $sunset, $fl) = $d->sunriseset();
  $sunrise = hms($sunrise);
  $sunset = hms($sunset);

  my $text_output = <<TEXT;
Hindu Panchangam for $display_day
Tithi:        $tithi
Nakshatra:    $nakshatra
Yoga:         $yoga
Karana:       $karana
Rahu Kalam:   $rahu_kalam
Gulika:       $gulika_kalam
Yamaganda:    $yamaganda_kalam
Durmuhurth:   $durmuhurtam
Varjya:       $varjyam
Sunrise:      $sunrise
Sunset:       $sunset
TEXT

  my $html_output = <<HTML;
<h6>Hindu Panchangam for $display_day</h6>
<div class="record">
  <table class="record__body">
    <tbody>
      <tr class="record__row ">
          <td class="record__cell__key ">Tithi:</td>
          <td class="record__cell__value">$tithi</td>
      </tr>

      <tr class="record__row ">
          <td class="record__cell__key ">Nakshatra:</td>
          <td class="record__cell__value">$nakshatra</td>
      </tr>

      <tr class="record__row ">
          <td class="record__cell__key ">Yoga:</td>
          <td class="record__cell__value">$yoga</td>
      </tr>

      <tr class="record__row ">
          <td class="record__cell__key ">Karana:</td>
          <td class="record__cell__value">$karana</td>
      </tr>

      <tr class="record__row ">
        <td class="record__cell__key ">Rahu Kalam:</td>
        <td class="record__cell__value">$rahu_kalam</td>
      </tr>

      <tr class="record__row ">
        <td class="record__cell__key ">Gulika:</td>
        <td class="record__cell__value">$gulika_kalam</td>
      </tr>

      <tr class="record__row ">
        <td class="record__cell__key ">Yamaganda:</td>
        <td class="record__cell__value">$yamaganda_kalam</td>
      </tr>

      <tr class="record__row ">
        <td class="record__cell__key ">Durmuhurth:</td>
        <td class="record__cell__value">$durmuhurtam</td>
      </tr>

      <tr class="record__row ">
        <td class="record__cell__key ">Varjya:</td>
        <td class="record__cell__value">$varjyam</td>
      </tr>

      <tr class="record__row ">
        <td class="record__cell__key ">Sunrise:</td>
        <td class="record__cell__value">$sunrise</td>
      </tr>

      <tr class="record__row ">
        <td class="record__cell__key ">Sunset:</td>
        <td class="record__cell__value">$sunset</td>
      </tr>

    </tbody>
  </table>
</div>
<style>
.zci__links .zci__prev, .zci__links .zci__next {
  display: inline-block;
  color: #888;
  font-size: 0.9167em;
}
.zci__links .zci__prev:hover, .zci__links .zci__next:hover {
  color: #2f82c2;
}
.zci__links .zci__prev:after {
  content: '|';
  margin-left: 5px;
  color: #888;
}
</style>
<div class="zci__links">
  <a href="/?q=panchangam+$prev_day" class="zci__prev">&laquo; Previous day</a>
  <a href="/?q=panchangam+$next_day" class="zci__next">Next day &raquo;</a>
</div>
HTML

  return answer => $text_output, html => $html_output;

};


1;
