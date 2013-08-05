package DDG::Goodie::SharkWeek;

use DDG::Goodie;
use JSON::XS;
use DateTime;

zci answer_type => 'schedule';

primary_example_queries 'shark week schedule';
secondary_example_queries 'shark week';
description 'see the schedule for shark week';
name 'Calculator';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Calculator.pm';
category 'entertainment';
topics 'entertainment';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
    github => [ 'https://github.com/duckduckgo', 'duckduckgo' ],
    twitter => ['http://twitter.com/duckduckgo', 'duckduckgo' ];

triggers start => 'shark';
my $schedule = decode_json(scalar share('shark.json')->slurp);

handle query_lc => sub {
    return unless $_ =~ /^shark week(?: schedule|)$/;
    my $dt = DateTime->today();
    my $key = $dt->day_name.' '.$dt->month_name . ' '.$dt->day;
    my @episodes = @{$schedule->{$key}};
#    return scalar(@episodes);

    my $html = "<ul>";
    my $txt = "$key Schedule\n";
    foreach my $e (@episodes) {
	my $time = $e->{'time'};
	my $title = $e->{'title'};
	my $description = $e->{'description'};
	$html .= "<li>$time - $title</li>";
	$txt .= "$time | $title\n";
    }
    $html .= "</ul>";
    
    return $txt, html => $html, heading => "$key Schedule";
};

1;
