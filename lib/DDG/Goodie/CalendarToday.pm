package DDG::Goodie::CalendarToday;
# ABSTRACT: Print calendar of current / given month and highlight today

use DDG::Goodie;
use Time::Piece;

primary_example_queries "calendar";
secondary_example_queries "calendar november 2015", 
                          "cal nov 2015", 
                          "cal nov", 
                          "cal next nov";

description "Print calendar of current / given month and highlight today";
name "Calendar Today";
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CalendarToday.pm';
category "dates";
topics "everyday";
attribution email   => ['webmaster@quovadit.org'];
triggers startend => 'calendar', 'cal';


# define variables
my $currentDay;
my $currentMonth;
my $currentYear;
my $givenDay;
my $givenMonth;
my $givenYear;
my $firstDay;
my $firstWeekDayId;
my $lastDay;
my $rText;
my $rHtml;

my @weekDays = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
  

handle remainder => sub {
  
  # Default: today
  my $t = localtime;
  $currentDay = $t->mday;
  $currentMonth = $t->mon;
  $currentYear = $t->year;


  # if valid input in remainder -> override year/month and unset day
  my ($par1, $par2) = split (' ', $_);

  # two parameters in remainder (month + year)
  if ($par2) {
    if(readYear($par2)) {
      return if (!readMonth($par1));
    } else {
      return if (!readMonth($par2));
      if (!readYear($par1)) {
        if($par1 eq "last") {
          lastMonth();
        } elsif($par1 eq "next") {
          nextMonth();
        } else {
          return;
        }
      }
    }
    
  # only one parameter (month)
  } elsif ($par1) {
      if (readMonth($par1)) {
        nearestMonth();
      } else {
        return;
      }

  # no parameter
  } else {
    $givenDay = $currentDay;
    $givenMonth = $currentMonth;
    $givenYear = $currentYear;
  }


  # calculate first/last day
  $firstDay = Time::Piece->strptime("$givenYear/$givenMonth/1", "%Y/%m/%d");
  $firstWeekDayId = $firstDay->day_of_week;
  $lastDay = $firstDay->month_last_day;


  prepare_returntext();

  return $rText, html => append_css($rHtml);
};




# functions:

# check if par is a valid month
sub readMonth {
  my @monthPatterns = ('%b', '%B', '%h');

  for my $monthPattern (@monthPatterns) {
    return 1 if(eval {
      my $validDate = Time::Piece->strptime("2000/$_[0]/1", "%Y/".$monthPattern."/%d");
      $givenDay = 0;
      $givenMonth = $validDate->mon;
    })
  }
}

# check if par is a valid year
sub readYear {
  my @yearPatterns = ('%y', '%Y');

  for my $yearPattern (@yearPatterns) {
    return 1 if(eval {
      my $validDate = Time::Piece->strptime("$_[0]/1/1", "".$yearPattern."/%m/%d");
      $givenYear = $validDate->year;
    })
  }
}

# find last month
sub lastMonth {

  if($givenMonth < $currentMonth) {
    $givenYear = $currentYear;
    return ($currentMonth - $givenMonth);
  } else { 
    $givenYear = $currentYear-1;
    return ($currentMonth+(12-$givenMonth));
  }
  
}

# find next month
sub nextMonth {

  if($givenMonth > $currentMonth) {
    $givenYear = $currentYear;
    return ($givenMonth - $currentMonth);
  } else { 
    $givenYear = $currentYear+1;
    return ($givenMonth+(12-$currentMonth));
  }

}

# find nearest month
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
  $rHtml = '<table><tr><th class="header" rowspan="6">';
  $rHtml.=$firstDay->strftime("%B %Y").'</th>';

  for my $dayHeading (@weekDays) {
    $rText.= "$dayHeading ";
    $rHtml.= '<th>&nbsp;'.$dayHeading.'</th>';
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
      $rHtml.= '<td class="today">'.$dayNum.'</td>';
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
  my $css = scalar share("style.css")->slurp;
  return "<style type='text/css'>$css</style>\n" . $html;
}




1;
