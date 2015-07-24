package DDG::Goodie::CalendarToday;
# ABSTRACT: Print calendar of current / given month and highlight (to)day

use strict;
use DDG::Goodie;
use DateTime;
use Try::Tiny;
use Text::Trim;
use URI::Escape::XS qw(encodeURIComponent);

with 'DDG::GoodieRole::Dates';

zci answer_type => 'calendar';
zci is_cached   => 0;

primary_example_queries "calendar";
secondary_example_queries "calendar november",
                          "calendar next november",
                          "calendar november 2015",
                          "cal 29 nov 1980",
                          "cal 29.11.1980",
                          "cal 1980-11-29";

description "Print calendar of current / given month and highlight (to)day";
name "Calendar Today";
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CalendarToday.pm';
category "dates";
topics "everyday";
attribution email   => ['webmaster@quovadit.org', 'webmaster@quovadit.org'];
triggers startend => 'calendar', 'cal';

# define variables
my @weekDays = ("S", "M", "T", "W", "T", "F", "S");

my $filler_words_regex         = qr/(?:\b(?:on|of|for|the|a)\b)/;
my $datestring_regex           = datestring_regex();
my $formatted_datestring_regex = formatted_datestring_regex();
my $relative_dates_regex       = relative_dates_regex();

handle remainder => sub {
    my $query       = $_;
    my $date_object = DateTime->now;
    my ($currentDay, $currentMonth, $currentYear) = ($date_object->day(), $date_object->month(), $date_object->year());
    my $highlightDay = 0;                  # Initialized, but won't match, by default.
    $query =~ s/$filler_words_regex//g;    # Remove filler words.
    $query =~ s/\s{2,}/ /g;                # Tighten up any extra spaces we may have left.
    $query =~ s/'s//g;                     # Remove 's for possessives.
    $query = trim $query;                  # Trim outside spaces.
    if ($query) {
        my ($date_string) = $query =~ qr#^($datestring_regex)$#i;    # Extract any datestring from the query.

        $date_object = parse_datestring_to_date($date_string);

        return unless $date_object;

        # Decide if a specific day should be highlighted.  If the query was not precise, eg "Nov 2009",
        # we can't hightlight.  OTOH, if they specified a date, we highlight.  Relative dates like "next
        # year", or "last week" exactly specify a date so they get highlighted also.
        $highlightDay = $date_object->day() if ($query =~ $formatted_datestring_regex || $query =~ $relative_dates_regex);
    }
    # Highlight today if it's this month and no other day was chosen.
    $highlightDay ||= $currentDay if (($date_object->year() eq $currentYear) && ($date_object->month() eq $currentMonth));

    my $the_year  = $date_object->year();
    my $the_month = $date_object->month();
    # return calendar
    my $start = parse_datestring_to_date($the_year . "-" . $the_month . "-1");
    my $plaintext = "calendar today";
    my @months;
    my %month_data;
    my $last_month_days = undef;
    my $month_last_day;
    my $last_day;
    my $month_date_object = DateTime->new(year=>$the_year, month=>$the_month);
    my $the_month_days;
    my @day_array;
    my $month = $the_month;
    my $first_day_month;
    my @prev_day_array;
    my @all_days;
    my @days_concat;
    my $counter;
    # for 12 months starting at current month
    for (my $month_index=0; $month_index < 12; $month_index++){
	my $start = parse_datestring_to_date($the_year . "-" . $the_month . "-1");
        $the_year = $month_date_object-> year();  
	$the_month = $month_date_object -> month();
        if (!$last_month_days){
            $last_month_days = DateTime->last_day_of_month(
                year => $month_date_object->clone()->subtract(months => 1)-> year(),
	        month => $month_date_object->clone()->subtract(months => 1)-> month()
            )->day();
        }
        
       $the_month_days = DateTime->last_day_of_month(
		year  => $the_year,
		month => $the_month
	      )->day();
    
       # get days of this month   
       @day_array = (1..$the_month_days);
       # get first day of this month
       $first_day_month = $month_date_object->day_of_week() % 7;
       # get days from previous month that will be rendered on calendar
       @prev_day_array = ($last_month_days-$first_day_month+1..$last_month_days);
       # concatenate previous days and this months days
       push @prev_day_array , @day_array;
       # add any days from the next month to fill empty space in calendar
       $counter = 1;
       while (@prev_day_array % 7 != 0){
           push @prev_day_array, $counter;
           $counter += 1; 
       }
       # divide into 7 days per row
       push @all_days, [ splice @prev_day_array, 0, 7 ] while @prev_day_array;
       # push this month onto months
       push @months, {
            first_day_num =>  $first_day_month,
            month => $the_month,
            month_name => $month_date_object->month_name(),
            year => $the_year, 
            days => [@all_days],
            last_month_days => $last_month_days
       };
       # go to next month
       $month_date_object = $month_date_object->subtract(months => -1);
       # save the days in this month
       $last_month_days = $the_month_days;
       # clear days
       @all_days = ();
    }
    # return months to handlebar template
    return $plaintext,
        structured_answer => {
            id => 'calendar',
            name => 'Answer',
            data => \@months,
            meta => {
               
            },
            templates => {
                group => 'base',
               detail => 0,
                options => {
                    content => 'DDH.calendar_today.content',
                }
            }
     };
};

1;
