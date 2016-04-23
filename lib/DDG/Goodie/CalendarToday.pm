package DDG::Goodie::CalendarToday;
# ABSTRACT: Print calendar of current / given month and highlight (to)day

use strict;
use DDG::Goodie;
use DateTime;
use Try::Tiny;
use URI::Escape::XS qw(encodeURIComponent);
use Text::Trim;
with 'DDG::GoodieRole::Dates';

zci answer_type => 'calendar';
zci is_cached   => 0;

triggers startend => 'calendar', 'cal';

# define variables
my @weekDays = ("S", "M", "T", "W", "T", "F", "S");

my $filler_words_regex         = qr/(?:\b(?:on(?: a)?|of|for|the)\b)/;

handle remainder => sub {
    my $query       = $_;
    my $date_object = DateTime->now;
    my $date_parser = date_parser();
    my ($currentDay, $currentMonth, $currentYear) = ($date_object->day(), $date_object->month(), $date_object->year());
    my $highlightDay = 0;                  # Initialized, but won't match, by default.
    $query =~ s/$filler_words_regex//g;    # Remove filler words.
    $query =~ s/\s{2,}/ /g;                # Tighten up any extra spaces we may have left.
    $query =~ s/'s//g;                     # Remove 's for possessives.
    $query = trim $query;                  # Trim outside spaces.
    if ($query) {
        $date_object = $date_parser->parse_datestring_to_date($query);

        return unless $date_object;

        # Decide if a specific day should be highlighted.  If the query was not precise, eg "Nov 2009",
        # we can't hightlight.  OTOH, if they specified a date, we highlight.  Relative dates like "next
        # year", or "last week" exactly specify a date so they get highlighted also.
        $highlightDay = $date_object->day()
            if ($date_parser->is_formatted_datestring($query)
                || $query =~ /in|ago/
                || $date_object->day != 1);
    }
    # Highlight today if it's this month and no other day was chosen.
    $highlightDay ||= $currentDay if (($date_object->year() eq $currentYear) && ($date_object->month() eq $currentMonth));

    my $the_year  = $date_object->year();
    my $the_month = $date_object->month();
    # return calendar
    my $start = $date_parser->parse_datestring_to_date($the_year . "-" . $the_month . "-1");
    return format_result({
            first_day     => $start,
            first_day_num => $start->day_of_week() % 7,                                    # 0=Sunday
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
    my $previous = $firstDay->clone->subtract(months => 1);
    my $next = $firstDay->clone->add(months => 1);

    # Print heading
    my $rText = "\n";

    for my $dayHeading (@weekDays) {
        $rText .= $dayHeading . ' ';
    }
    $rText .= "     ".$firstDay->strftime("%B %Y")."\n";

    # Skip to the first day of the week
    $rText .= "    " x $first_day_num;

    my @weeks;
    my @week_day;
    for (my $t = 1; $t <= $first_day_num; $t++) {
        push @week_day, {"day", " ", "today", ""};
    }
    my $weekDayNum = $first_day_num;

    # Printing the month
    for (my $dayNum = 1; $dayNum <= $lastDay; $dayNum++) {
        my $padded_date = sprintf('%2s', $dayNum);
        if ($dayNum == $highlightDay) {
            $rText .= '|' . $padded_date . '|';
            push @week_day, {"day", $dayNum, "today", "1"};
        } else {
            $rText .= ' ' . $padded_date . ' ';
            push @week_day, {"day", $dayNum, "today", ""};
        }
        # next row after 7 cells
        $weekDayNum++;
        if ($weekDayNum == 7) {
            push @weeks, [@week_day];
            $weekDayNum = 0;
            undef @week_day;
            $rText .= "\n";
        }
    }
    if (@week_day) {
        push @weeks, [@week_day];
    }
    $rText .= "\n";

    return $rText,
    structured_answer => {
        data => {
            month_year => $firstDay->strftime("%B %Y"),
            previous_month => $previous->strftime("%B %Y"),
            next_month => $next->strftime("%B %Y"),
            weeks => \@weeks,
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.calendar_today.content'
            }
        }
    };
};

1;
