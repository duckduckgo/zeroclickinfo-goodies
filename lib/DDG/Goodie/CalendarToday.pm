package DDG::Goodie::CalendarToday;
# ABSTRACT: Print calendar of current / given month and highlight today

use DDG::Goodie;
use Time::Piece;

primary_example_queries "calendar";
secondary_example_queries "calendar april",
                          "calendar sep 2015";

description "Print calendar of current / given month and highlight today";
name "Calendar Today";
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CalendarToday.pm';
category "dates";
topics "everyday";
attribution email   => ['webmaster@quovadit.org'];
triggers start => 'calendar';


handle remainder => sub {
  
  # define days & months
  my @weekDays = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
  my %monthsShort = ("jan" => 1, "feb" => 2, "mar" => 3, "apr" => 4, "may" => 5, "jun" => 6, 
	"jul" => 7, "aug" => 8, "sep" => 9, "oct" => 10, "nov" => 11, "dec" => 12);
  
  my %monthsLong = ("january" => 1, "february" => 2, "march" => 3, "april" => 4, "may" => 5, "june" => 6, 
	"july" => 7, "august" => 8, "september" => 9, "october" => 10, "november" => 11, "december" => 12);
  
  
  # Default: today
  my ($day, $monthId, $yearOffset) = (localtime)[3,4,5];
  my $month = 1 + $monthId;
  my $year = 1900 + $yearOffset;
  
  
  # if valid input in remainder -> override year/month and unset day
  if ($_) { 
    my $givenMonth = "";
    my $givenYear = "";
    my $whiteSpace = index($_, " ");
    
    # more than one parameter (month + year)
    if($whiteSpace > 0) {
      $givenMonth = substr $_, 0, $whiteSpace;
      $givenYear = substr $_, $whiteSpace+1, 4;
      
      if(is_integer($givenYear) && $givenYear > 1900 && $givenYear < 2100) { 
        $year = $givenYear; 
        $day = 0;
      }
    # only one parameter (month)
    } else {
      $givenMonth = $_;
    }
    
    # lookup month name
    if($monthsShort{$givenMonth}) { 
      $month = $monthsShort{$givenMonth}; 
      $day = 0;
    } elsif($monthsLong{$givenMonth}) { 
      $month = $monthsLong{$givenMonth}; 
      $day = 0;
    } else {
      return;
    }
  }


  # calculate first/last day
  my $firstDay = Time::Piece->strptime("$year/$month/1", "%Y/%m/%d");
  my $firstWeekDayId = $firstDay->day_of_week;
  my $lastDay = $firstDay->month_last_day;


  # Print heading
  my $rText = "\n";
  my $rHtml = '<table style="text-align:center;"><tr><th style="width:150px; text-align:left;">';
  $rHtml.=$firstDay->strftime("%B %Y").'</th>';

  for my $dayHeading (@weekDays) {
    $rText.= "$dayHeading ";
    $rHtml.= '<th style="width:40px; text-align:center;">'.$dayHeading.'</th>';
  }
  $rText.= "     ".$firstDay->strftime("%B %Y")."\n";
  $rHtml.= "</tr><tr><td>&nbsp;</td>";
   

  # Skip to the first day of the week
  $rText.= "    " x $firstWeekDayId;
  $rHtml.= "<td>&nbsp;</td>" x $firstWeekDayId;
  my $weekDayNum = $firstWeekDayId;
   
  
  # Printing the month
  for (my $dayNum = 1; $dayNum <= $lastDay; $dayNum++) {
    if($dayNum == $day) { 
      $rText.= "|"; 
      $rHtml.= '<td style="color:white; background-color: #808080;">'.$dayNum.'</td>';
    } else {
      $rText.=" "; 
    }
    
    if($dayNum < 10) { 
      $rText.=" "; 
    }

    $rText.= "$dayNum";
    if($dayNum != $day ) {
      $rHtml.= "<td>$dayNum</td>";
    }
    
    if($dayNum == $day) { 
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
      $rHtml.= "</tr><tr><td>&nbsp;</td>";
    }
  }

  $rText.= "\n";
  $rHtml.="</tr></table>";


  return $rText, html => $rHtml;
};


sub is_integer {
   defined $_[0] && $_[0] =~ /^[+-]?\d+$/;
}

1;
