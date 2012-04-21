package DDG::Goodie::DaysBetween;
# ABSTRACT: Give the number of days between two given dates.

use DDG::Goodie;
use Date::Calc qw( Date_to_Days); 
use Time::localtime;

triggers startend => "days", "daysbetween", "days_between";
zci is_cached => 1;
zci answer_type => "days_between";


handle query_lc => sub {

	s/^days(?:\s|_)*between//;
	@dates = $_ =~ m#([01]?[0-9])/([0-3]?[0-9])/([0-9]{4}(?=\s|$))#g;

	if(scalar(@dates) == 3) {
		$tm=localtime;
		push(@dates, $tm->mon + 1, $tm->mday, $tm->year + 1900);
	}

	if(scalar(@dates) == 6) {

		eval {
			$days1 = Date_to_Days(@dates[2], @dates[0], @dates[1]);
			$days2 = Date_to_Days(@dates[5], @dates[3], @dates[4]);
		};
		if ($@) {
			return;
		}
		$daysBetween = abs($days2 - $days1);
        if(/inclusive/) {
            $daysBetween += 1;
            $inclusive = ', inclusive';
        }
        $startDate = @dates[0] . '/' . @dates[1] . '/' . @dates[2];
        $endDate = @dates[3] . '/' . @dates[4] . '/' . @dates[5];
		return 'There are ' . $daysBetween ." days between ". $startDate . ' and ' . $endDate . $inclusive . '.';
	}
	return;
};

1;
