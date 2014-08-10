package DDG::Goodie::CalendarConversion;

use DDG::Goodie;
use Date::Hijri;
use Date::Jalali2;

zci answer_type => "conversion";
primary_example_queries '22/8/2003 to the hijri calendar';
secondary_example_queries '23/6/1424 hijri to gregorian';
description 'convert dates from the Gregorian calendar to the Hijri/Jalali calendars and back';
name 'CalendarConversion';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CalendarConversion.pm';
category 'dates';
topics 'special_interest';
attribution
    github => [ 'http://github.com/mattlehning', 'mattlehning' ],
    github => [ 'http://github.com/ehsan', 'ehsan' ];

triggers any => 'hijri', 'gregorian', 'jalali';

my %calendars = (
    'gregorian' => ['Gregorian calendar', '<a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>'],
    'hijri' => ['Hijri calendar','<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>'],
    'jalali' => ['Jalali calendar','<a href="https://en.wikipedia.org/wiki/Jalali_calendar">Jalali calendar</a>'],
);

# This function returns either the HTML version of the output or the text version.
sub output {
    my ($calendar_first, $calendar_second, $input_date, $converted_date, $is_html) = @_;

    return "$input_date on the " . $calendars{$calendar_first}[$is_html] . " is $converted_date on the " . $calendars{$calendar_second}[$is_html] . '.';
}

handle query_lc => sub {
	return unless my ($d, $m, $y, $input_calendar, $output_calendar) = $_ =~
        /^
            (\d{0,2})(?:\/|,)(\d{0,2})(?:\/|,)(\d{3,4})\s+
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
            (?:calendar|date|time|years|months|days)?
        $/x;
	
	return unless ($d < 32 and $m < 12);

        $input_calendar //= 'gregorian'; # gregorian is the default
        return if ($input_calendar eq $output_calendar);

	my $input_date = "$d/$m/$y";
        my $converted_date;

        if ($input_calendar eq "hijri" and $output_calendar eq "gregorian") {
            my ($gd, $gm, $gy) = h2g($d, $m, $y);
            $converted_date = "$gd/$gm/$gy";
        }
        elsif ($input_calendar eq "gregorian" and $output_calendar eq "hijri") {
            my ($hd, $hm, $hy) = g2h($d, $m, $y);
            $converted_date = "$hd/$hm/$hy";
        }
        elsif ($input_calendar eq "jalali" and $output_calendar eq "gregorian") {
            my $t = new Date::Jalali2($y, $m, $d, 1);
            $converted_date = $t->jal_day . "/" . $t->jal_month . "/" . $t->jal_year;
        }
        elsif ($input_calendar eq "gregorian" and $output_calendar eq "jalali") {
            my $t = new Date::Jalali2($y, $m, $d, 0);
            $converted_date = $t->jal_day . "/" . $t->jal_month . "/" . $t->jal_year;
        }
        elsif ($input_calendar eq "hijri" and $output_calendar eq "jalali") {
            my ($gd, $gm, $gy) = h2g($d, $m, $y);
            my $t = new Date::Jalali2($gy, $gm, $gd, 0);
            $converted_date = $t->jal_day . "/" . $t->jal_month . "/" . $t->jal_year;
        }
        elsif ($input_calendar eq "jalali" and $output_calendar eq "hijri") {
            my $t = new Date::Jalali2($y, $m, $d, 1);
	    my ($hd, $hm, $hy) = g2h($t->jal_day, $t->jal_month, $t->jal_year);
	    $converted_date = "$hd/$hm/$hy";
        }

	return output($input_calendar, $output_calendar, $input_date, $converted_date, 0),
	html => output($input_calendar, $output_calendar, $input_date, $converted_date, 1);
};

1;
