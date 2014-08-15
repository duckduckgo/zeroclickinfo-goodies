package DDG::Goodie::CalendarToday;
# ABSTRACT: Print calendar of current / given month and highlight (to)day

use DDG::Goodie;
use DateTime;
use DateTime::TimeZone; 
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
my $givenDay = 0;
my $firstDay, my $firstWeekDayId, my $lastDay;
my $rText, my $rHtml;
my @weekDays = ("S", "M", "T", "W", "T", "F", "S");
  
# read in css-file only once
my $css = share("style.css")->slurp;

my $month_regex = full_month_regex();
my $date_regex = date_regex();

handle remainder => sub {
    my $query = $_;
    # check current date in users timezone
    my $t = DateTime->now; 
    $t->set_time_zone($loc->time_zone);
    my ($currentDay, my $currentMonth, my $currentYear) = ($t->mday, $t->mon, $t->year);
    my $date_object = DateTime->now;
    if($query) {
        my ($date_string, $other_format) = $query =~ qr#($date_regex)|((?:next|last )?$month_regex(?: [0-9]{4})?)#i;
        if($date_string) {
            $date_object = parse_string_to_date($date_string);

            return unless $date_object;
            $givenDay = $date_object->day();
        }
        elsif($other_format) {
            $date_object = parsePsuedoDate($other_format);

            return unless $date_object;
            # highlight today if current month is given
            if(($date_object->year() eq $currentYear) && ($date_object->month() eq $currentMonth)) {
                $givenDay = $currentDay;
            }
        }
        else {
            return;
        }
    }
    # calculate first/last day
    $firstDay = parse_string_to_date($date_object->year()."-".$date_object->month()."-1");
    $firstWeekDayId = $firstDay->day_of_week()%7; # 0=Sun;6=Sat
    $lastDay = DateTime->last_day_of_month( year =>$date_object->year(), month =>$date_object->month())->day();

    # return calendar
    prepare_returntext();
    return $rText, html => append_css($rHtml);
};

# functions:
sub parsePsuedoDate {
    my ($string) = @_;
    return parse_vague_string_to_date($string);
}

# prepare text and html to be returned
sub prepare_returntext {
  # Print heading
  $rText = "\n";
  $rHtml = '<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>';
  $rHtml .= $firstDay->strftime("%B %Y").'</b></th></tr><tr>';

  for my $dayHeading (@weekDays) {
    $rText .= "$dayHeading ";
    $rHtml .= '<th>'.$dayHeading.'</th>';
  }
  $rText .= "     ".$firstDay->strftime("%B %Y")."\n";
  $rHtml .= "</tr><tr>";
   

  # Skip to the first day of the week
  $rText .= "    " x $firstWeekDayId;
  $rHtml .= "<td>&nbsp;</td>" x $firstWeekDayId;
  my $weekDayNum = $firstWeekDayId;
   
  
  # Printing the month
  for (my $dayNum = 1; $dayNum <= $lastDay; $dayNum++) {
    if($dayNum == $givenDay) { 
      $rText .= "|"; 
      $rHtml .= '<td><span class="calendar__today circle">'.$dayNum.'</span></td>';
    } else {
      $rText .=" "; 
    }
    
    if($dayNum < 10) { 
      $rText .=" "; 
    }

    $rText .= "$dayNum";
    if($dayNum != $givenDay ) {
      $rHtml .= "<td>$dayNum</td>";
    }
    
    if($dayNum == $givenDay) { 
      $rText .= "|"; 
      $rHtml .= "</div>";
    } else {
      $rText .=" "; 
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

}

sub append_css {
  my $html = shift;
  return "<style type='text/css'>$css</style>\n" . $html;
}

1;