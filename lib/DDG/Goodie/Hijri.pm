package DDG::Goodie::Hijri;
# ABSTRACT: convert between Gregorian and Hiriji calendars.

use DDG::Goodie;

use Date::Hijri;

zci answer_type => "conversion";
primary_example_queries '22/8/2003 to the hijri calendar';
secondary_example_queries '23/6/1424 to gregorian';
description 'convert dates from the Gregorian calendar to the Hijri calendar and back';
name 'Hijri';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Hijri.pm';
category 'dates';
topics 'special_interest';
attribution github => [ 'http://github.com/mattlehning', 'mattlehning' ];

triggers any => 'hijri', 'gregorian';

my %calendars = (
    'gregorian' => ['Gregorian calendar', '<a href="https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>'],
    'hijri' => ['Hijri calendar','<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>'],
);

# This function returns either the HTML version of the output or the text version.
sub output {
    my ($calendar_first, $calendar_second, $input_date, $converted_date, $is_html) = @_;

    return "$input_date on the " . $calendars{$calendar_first}[$is_html] . " is $converted_date on the " . $calendars{$calendar_second}[$is_html] . '.';
}

handle query_lc => sub {
	return unless my ($gd, $gm, $gy, $requested_calendar) = $_ =~
        /^
            (\d{0,2})(?:\/|,)(\d{0,2})(?:\/|,)(\d{3,4})\s+
            (?:
                (?:on\s+the)\s+
                (?:gregorian|hijri)\s+
                (?:calendar|date|time)\s+
                is\s+
            )?
            (?:
                (?:(?:in|on|to)(?:\s+the|in)?)\s+
            )?
            (gregorian|hijri)\s*
            (?:calendar|date|time|years|months|days)?
        $/x;
	
	return unless ($gd < 31 and $gm < 12);

	my $is_hijri = $requested_calendar eq 'hijri';

	my ($hd, $hm, $hy) = $is_hijri ? g2h($gd, $gm, $gy) : h2g($gd, $gm, $gy);
	my $input_date     = "$gd/$gm/$gy";
	my $converted_date = "$hd/$hm/$hy";

	# Check if the user wants to convert to either Hijri or Gregorian.
	if($is_hijri) {
	    return output('gregorian', 'hijri', $input_date, $converted_date, 0), 
	    html => output('gregorian', 'hijri', $input_date, $converted_date, 1);  
	}
	return output('hijri', 'gregorian', $input_date, $converted_date, 0),
	html => output('hijri', 'gregorian', $input_date, $converted_date, 1);
};

1;
