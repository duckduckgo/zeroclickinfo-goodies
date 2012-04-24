package DDG::Goodie::UnixTime;

use DDG::Goodie;

zci answer_type => "time_conversion";
zci is_cached => 1;
triggers startend => "unixtime", "time", "timestamp", "datetime", "epoch";

handle remainder => sub {

	my $time_input = int(length ($_) >= 13 ? ($_ / 1000) : ($_ + 0));

	if ($time_input >= 0){
	
		my $my_time = localtime($time_input);

		return $my_time if $my_time;
	
	}

    return;

};

1;