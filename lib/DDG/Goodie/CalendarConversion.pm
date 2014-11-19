package DDG::Goodie::CalendarConversion;
# ABSTRACT: convert between various calendars.

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use Date::Hijri;
use Date::Jalali2;

use YAML::XS qw(Load);

zci answer_type => "calendar_conversion";
zci is_cached   => 0;

primary_example_queries '22/8/2003 to the hijri calendar';
secondary_example_queries '23/6/1424 hijri to gregorian';
description 'convert dates from the Gregorian calendar to the Hijri/Jalali calendars and back';
name 'CalendarConversion';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CalendarConversion.pm';
category 'dates';
topics 'special_interest';
attribution github => ['http://github.com/mattlehning', 'mattlehning'],
            github => ['http://github.com/ehsan',       'ehsan'];

triggers any => 'hijri', 'gregorian', 'jalali';

my $calendars = Load(scalar share('calendars.yml')->slurp);

my $datestring_regex = datestring_regex();

sub format_date {
    my ($d, $m, $y, $cal) = @_;

    return join(' ', $d, $calendars->{$cal}->[$m - 1], $y, '(' . ucfirst $cal . ')');
}

handle query_lc => sub {
    return unless my ($datestring, $input_calendar, $output_calendar) = $_ =~ /^
            ($datestring_regex)\s+
            (?:
                (?:(?:in|on(?:\s+the))?)\s*
                ((?:gregorian|hijri|jalali)?)\s+
                (?:calendar|date|time)?\s*
                (?:is\s+)?
            )?
            (?:
                (?:(?:in|on|to)(?:\s+the|in)?)\s+
            )?
            (gregorian|hijri|jalali)\s*
            (?:calendar|date|time|years)?
        $/x;
    my $in_date = parse_datestring_to_date($datestring);
    return unless $in_date;
    my ($d, $m, $y) = ($in_date->day, $in_date->month, $in_date->year);

    $input_calendar ||= 'gregorian';    # gregorian is the default
    return if ($input_calendar eq $output_calendar || !$output_calendar);

    my ($od, $om, $oy);

    if ($input_calendar eq "hijri") {
        ($od, $om, $oy) = h2g($d, $m, $y);    # To Gregorian;
        ($od, $om, $oy) = g2j($od, $om, $oy) if ($output_calendar eq "jalali");
    } elsif ($input_calendar eq "gregorian") {
        ($od, $om, $oy) = g2h($d, $m, $y) if ($output_calendar eq "hijri");
        ($od, $om, $oy) = g2j($d, $m, $y) if ($output_calendar eq "jalali");
    } elsif ($input_calendar eq "jalali") {
        my $t = new Date::Jalali2($y, $m, $d, 1);
        ($od, $om, $oy) = ($t->jal_day, $t->jal_month, $t->jal_year);
        ($od, $om, $oy) = g2h($od, $om, $oy) if ($output_calendar eq "hijri");
    }
    my $input_date     = format_date($d,  $m,  $y,  $input_calendar);
    my $converted_date = format_date($od, $om, $oy, $output_calendar);

    return $input_date . ' is ' . $converted_date,
      structured_answer => {
        input     => [$input_date],
        operation => 'calendar conversion',
        result    => $converted_date
      };
};

sub g2j {
    my ($id, $im, $iy) = @_;

    my $t = new Date::Jalali2($iy, $im, $id, 0);
    return ($t->jal_day, $t->jal_month, $t->jal_year);
}

1;
