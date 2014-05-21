package DDG::Goodie::CalendarToday;
# ABSTRACT: Print calendar of current / given month and highlight (to)day

use DDG::Goodie;
use Time::Piece;
use DateTime;
use DateTime::TimeZone; 

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
my $parameter1, my $parameter2, my $parameter3;
my $currentDay, my $currentMonth, my $currentYear;
my $givenDay, my $givenMonth, my $givenYear;
my $validMonthPattern, my $validYearPattern;
my $firstDay, my $firstWeekDayId, my $lastDay;
my $rText, my $rHtml;
my @weekDays = ("S", "M", "T", "W", "T", "F", "S");
  
# read in css-file only once
my $css = share("style.css")->slurp;


handle remainder => sub {
  
  # check current date in users timezone
  my $t = DateTime->now; 
  $t->set_time_zone($loc->time_zone);
  $currentDay = $t->mday;
  $currentMonth = $t->mon;
  $currentYear = $t->year;

  # read parameters - do not trigger if invalid parameters are found (delimiters: - / . ' ')
  ($parameter1, $parameter2, $parameter3) = split (/[-\/. ]/, $_);
  return if (!readParameters());

  # hightlight today if current month is given
  if(($givenYear eq $currentYear) && ($givenMonth eq $currentMonth)) {
    $givenDay = $currentDay;
  }

  # calculate first/last day
  $firstDay = Time::Piece->strptime("$givenYear/$givenMonth/1", "%Y/%m/%d");
  $firstWeekDayId = $firstDay->day_of_week;
  $lastDay = $firstDay->month_last_day;

  # return calendar
  prepare_returntext();
  return $rText, html => append_css($rHtml);
};




# functions:


# read up to 3 parameters, return 1 (OK) if valid date-combination is found
sub readParameters {

  # three parameters:
  if ($parameter3) {
    # e.g. "calendar 29 nov 1980"
    return 1 if((readYear($parameter3)) && (readMonth($parameter2)) && (readDay($parameter1)));
    # e.g. "calendar 1980 nov 29"
    return 1 if((readYear($parameter1)) && (readMonth($parameter2)) && (readDay($parameter3)));
    # e.g. "calendar nov 29 1980"
    return 1 if((readYear($parameter3)) && (readMonth($parameter1)) && (readDay($parameter2)));
    # e.g. "calendar 1980 29 nov"
    return 1 if((readYear($parameter1)) && (readMonth($parameter3)) && (readDay($parameter2)));
    # e.g. "calendar nov 1980 29"
    return 1 if((readYear($parameter2)) && (readMonth($parameter1)) && (readDay($parameter3)));
    # e.g. "calendar 29 1980 nov"
    return 1 if((readYear($parameter2)) && (readMonth($parameter3)) && (readDay($parameter1)));

  # two parameters:
  } elsif ($parameter2) {
    # e.g. "calendar next november"
    if (($parameter1 eq "next") && (readMonth($parameter2))) {
      nextMonth();
      return 1;
    } 
    # e.g. "calendar last november"
    if (($parameter1 eq "last") && (readMonth($parameter2))) {
      lastMonth();
      return 1;
    }
    # e.g. "calendar november 2015"
    return 1 if(readMonth($parameter1) && readYear($parameter2));

    # e.g. "calendar 2015 november"
    return 1 if(readMonth($parameter2) && readYear($parameter1));
  
  # only one parameter
  } elsif ($parameter1) {
      # e.g. "calendar november"
      if (readMonth($parameter1)) {
        nearestMonth();
        return 1;
      # "calendar today"
      } elsif ($parameter1 eq "today") {
        useToday();
        return 1;
      } else {
        return;
      }

  # no parameter -> "calendar"
  } else {
    useToday();
    return 1;
  }

  # no valid parameter-combination found
  return;

}


# check if parameter is a valid month (using strptime to allow different notations)
sub readMonth {
  # month name as full name (April), in abbreviated form (Apr) or as 2 digit (04) 
  my @monthPatterns = ('%B', '%b', '%m');

  for my $monthPattern (@monthPatterns) {
    return 1 if(eval {
      my $validDate = Time::Piece->strptime("2000/$_[0]/1", "%Y/".$monthPattern."/%d");
      $givenDay = 0;
      $givenMonth = $validDate->mon;
    })
  }
}

# check if parameter is a valid year (starting with 1900)
sub readYear {
  # year within century (2 digits) or including century (4 digits)
  my @yearPatterns = ('%y', '%Y');

  for my $yearPattern (@yearPatterns) {
    return 1 if(eval {
      my $validDate = Time::Piece->strptime("$_[0]/1/1", "".$yearPattern."/%m/%d");
      $givenYear = $validDate->year;
    })
  }
}

# check if parameter is a valid day (fitting given year+month)
sub readDay {
    return 1 if(eval {
      # prevent using 4digit year as day (cal 2012 11 10 -> 20th Nov 2010)
      return 0 if($_[0] > 31);

      # check if day exists (e.g. 29.2.2014: mday=1)
      my $validDate = Time::Piece->strptime("$givenYear/$givenMonth/$_[0]", "%Y/%m/%d");
      return 0 if($validDate->mday != $_[0]);

      $givenDay = $_[0];

    })

}

# use today as givenDay
sub useToday {
  $givenDay = $currentDay;
  $givenMonth = $currentMonth;
  $givenYear = $currentYear;
}

# find last month (searching for 'last january' in december 2014 gives 'january 2014')
sub lastMonth {

  if($givenMonth < $currentMonth) {
    $givenYear = $currentYear;
    return ($currentMonth - $givenMonth);
  } else { 
    $givenYear = $currentYear-1;
    return ($currentMonth+(12-$givenMonth));
  }
  
}

# find next month (searching for 'next january' in december 2014 gives 'january 2015')
sub nextMonth {

  if($givenMonth > $currentMonth) {
    $givenYear = $currentYear;
    return ($givenMonth - $currentMonth);
  } else { 
    $givenYear = $currentYear+1;
    return ($givenMonth+(12-$currentMonth));
  }

}

# find nearest month (searching for 'january' in december 2014 gives 'january 2015' = nextMonth)
sub nearestMonth {
  if($givenMonth == $currentMonth) {
    $givenYear = $currentYear;
  } elsif(lastMonth() < nextMonth()) {
    lastMonth();
  } elsif(lastMonth() > nextMonth()) {
    nextMonth();
  } elsif(lastMonth() == nextMonth()) {
    if($currentDay<($lastDay/2)) {
      lastMonth();
    } else {
      nextMonth();
    }
  } 
}

# prepare text and html to be returned
sub prepare_returntext {
  # Print heading
  $rText = "\n";
  $rHtml = '<table class="calendar"><tr><th class="calendar__header" colspan="7"><b>';
  $rHtml.=$firstDay->strftime("%B %Y").'</b></th></tr><tr>';

  for my $dayHeading (@weekDays) {
    $rText.= "$dayHeading ";
    $rHtml.= '<th>'.$dayHeading.'</th>';
  }
  $rText.= "     ".$firstDay->strftime("%B %Y")."\n";
  $rHtml.= "</tr><tr>";
   

  # Skip to the first day of the week
  $rText.= "    " x $firstWeekDayId;
  $rHtml.= "<td>&nbsp;</td>" x $firstWeekDayId;
  my $weekDayNum = $firstWeekDayId;
   
  
  # Printing the month
  for (my $dayNum = 1; $dayNum <= $lastDay; $dayNum++) {
    if($dayNum == $givenDay) { 
      $rText.= "|"; 
      $rHtml.= '<td><span class="calendar__today circle">'.$dayNum.'</span></td>';
    } else {
      $rText.=" "; 
    }
    
    if($dayNum < 10) { 
      $rText.=" "; 
    }

    $rText.= "$dayNum";
    if($dayNum != $givenDay ) {
      $rHtml.= "<td>$dayNum</td>";
    }
    
    if($dayNum == $givenDay) { 
      $rText.= "|"; 
      $rHtml.= "</div>";
    } else {
      $rText.=" "; 
    }
    
    # next row after 7 cells
    $weekDayNum++;
    if ($weekDayNum == 7) {
      $weekDayNum = 0;
      $rText.= "\n";
      $rHtml.= "</tr><tr>";
    }
  }

  $rText.= "\n";
  $rHtml.="</tr></table>";

}


sub append_css {
  my $html = shift;
  return "<style type='text/css'>$css</style>\n" . $html;
}




1;
