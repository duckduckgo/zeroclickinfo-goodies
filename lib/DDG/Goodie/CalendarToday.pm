package DDG::Goodie::CalendarToday;
# ABSTRACT: Print calendar of current / given month and highlight (to)day

use DDG::Goodie;
use DateTime;
use Try::Tiny;
with 'DDG::GoodieRole::Dates';

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
attribution email   => ['webmaster@quovadit.org'];
triggers startend => 'calendar', 'cal';

# define variables
my @weekDays = ("S", "M", "T", "W", "T", "F", "S");
  
# read in css-file only once
my $css = share("style.css")->slurp;

my $month_regex = month_regex();
my $date_regex  = date_regex();

handle remainder => sub {
    my $query       = $_;
    my $date_object = DateTime->now;
    my ($currentDay, $currentMonth, $currentYear) = ($date_object->day(), $date_object->month(), $date_object->year());
    my $highlightDay = 0; # Initialized, but won't match, by default.
    if ($query) {
        my ($date_string, $other_format) = $query =~ qr#($date_regex)|((?:(?:next|last) )?$month_regex(?: [0-9]{4})?)#i;
        if ($date_string) {
            $date_object = parse_string_to_date($date_string);

            return unless $date_object;
            $highlightDay = $date_object->day();
        } elsif ($other_format) {
            $date_object = parse_vague_string_to_date($other_format);

            return unless $date_object;
            # highlight today if current month is given
            if (($date_object->year() eq $currentYear) && ($date_object->month() eq $currentMonth)) {
                $highlightDay = $currentDay;
            }
        }
    } else {
        $highlightDay = $currentDay;
    }

    my $the_year  = $date_object->year();
    my $the_month = $date_object->month();
    # return calendar
    my $start = parse_string_to_date($the_year . "-" . $the_month . "-1");
    return format_result({
            first_day     => $start,
            first_day_num => $start->day_of_week() % 7, # 0=Sunday
            last_day      => DateTime->last_day_of_month(
                year  => $the_year,
                month => $the_month,
              )->day(),
            highlight => $highlightDay,
        });
};

# prepare text and html to be returned
sub format_result {
    my $args = shift;
    my ($firstDay, $first_day_num, $lastDay, $highlightDay) = @{$args}{qw(first_day first_day_num last_day highlight)};
    
    # Print heading
    my $rText = "\n";
    my $rHtml = '<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>';
    $rHtml .= $firstDay->strftime("%B %Y").'</b></th></tr><tr>';

    for my $dayHeading (@weekDays) {
        $rText .= $dayHeading . ' ';
        $rHtml .= '<th>' . $dayHeading . '</th>';
    }
    $rText .= "     ".$firstDay->strftime("%B %Y")."\n";
    $rHtml .= "</tr><tr>";

    # Skip to the first day of the week
    $rText .= "    " x $first_day_num;
    $rHtml .= "<td>&nbsp;</td>" x $first_day_num;
    my $weekDayNum = $first_day_num;

    # Printing the month
    for (my $dayNum = 1; $dayNum <= $lastDay; $dayNum++) {
        my $padded_date = sprintf('%2s', $dayNum);
        if ($dayNum == $highlightDay) {
            $rText .= '|' . $padded_date . '|';
            $rHtml .= '<td><span class="calendar__today circle">' . $dayNum . '</span></td>';
        } else {
            $rText .= ' ' . $padded_date . ' ';
            $rHtml .= "<td>$dayNum</td>";
        }

        # next row after 7 cells
        $weekDayNum++;
        if ($weekDayNum == 7) {
          $weekDayNum = 0;
          $rText .= "\n";
          $rHtml .= "</tr><tr>";
        }
    }

    $rText .= "\n";
    $rHtml .="</tr></table>";

    return $rText, html => append_css($rHtml);
}

sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
}

1;
