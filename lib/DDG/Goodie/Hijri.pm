package DDG::Goodie::Hijri;

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

my $gregorian_calendar_wiki =
    '<a href = "https://en.wikipedia.org/wiki/Gregorian_calendar">Gregorian calendar</a>';
my $hijri_calendar_wiki =
    '<a href="https://en.wikipedia.org/wiki/Hijri_calendar">Hijri calendar</a>';

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
	return unless ($gd<31 and $gm<12);
	my ($hd, $hm, $hy) = $requested_calendar eq 'hijri' ?
        g2h($gd, $gm, $gy) : h2g($gd, $gm, $gy);
    my $input_date     = "$gd/$gm/$gy";
    my $converted_date = "$hd/$hm/$hy";
	return "$input_date on the "
            . ($requested_calendar eq 'hijri' ?
                "$gregorian_calendar_wiki is $converted_date on the $hijri_calendar_wiki" :
                "$hijri_calendar_wiki is $converted_date on the $gregorian_calendar_wiki");

};

1;
