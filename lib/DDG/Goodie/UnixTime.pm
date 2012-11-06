package DDG::Goodie::UnixTime;

use DDG::Goodie;
use DateTime;

triggers startend => "unixtime", "time", "timestamp", "datetime", "epoch", "unix time", "unix epoch";

zci answer_type => "time_conversion";
zci is_cached => 1;

attribution github => ['https://github.com/codejoust', 'codejoust'];

primary_example_queries 'unix time 0000000000000';
secondary_example_queries 'epoch 0', 'epoch 2147483647';
description 'convert a unix epoch to human-readable time';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UnixTime.pm';
category 'calculations';
topics 'sysadmin';

handle remainder => sub {

    my $time_input = 0;
    eval {
	    $time_input = int(length ($_) >= 13 ? ($_ / 1000) : ($_ + 0));
    };
    if ($@) { return; }

	if ($time_input >= 0){

		my $my_time = DateTime->from_epoch(
            epoch => $time_input,
            time_zone => "UTC"
          );

        my $time_utc = $my_time->strftime("%a %b %d %T %Y %z");

		return "Unix Time Conversion: " . $time_utc if $time_utc;
	
	}

    return;

};

1;
