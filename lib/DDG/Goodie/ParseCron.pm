package DDG::Goodie::ParseCron;
# ABSTRACT: Parsing Crontabs - Show next occurence of cron event in human-readable form.
# Example input:
#     crontab 42 12 3 Feb Sat
# Example output:
#     Event will start next at 12:42:00 on 2 Feb, 2013
#

use DDG::Goodie;
use Schedule::Cron::Events;

my @mon = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my @day = qw(Mon Tue Wed Thu Fri Sat Sun);

triggers start => 'crontab';
zci is_cached => 0;
handle remainder => sub {
    my $crontab = $_;
    # We replace Jan,Feb.. and Mon,Tue.. with 1,2..
    foreach (0..$#mon) {
	my $newmonth=$_+1;
	$crontab =~ s/$mon[$_]/$newmonth/;
    }
    foreach (0..$#day) {
	my $newday=$_+1;
	$crontab =~ s/$day[$_]/$newday/;
    }
    my $cron = new Schedule::Cron::Events($crontab) or return;
    my ($sec, $min, $hour, $day, $month, $year) = $cron->nextEvent;
    $year = $year+1900;
    my $text = sprintf qq(Event will start next at %02d:%02d:%02d on %d %s, %d), $hour, $min, $sec, $day, $mon[$month], $year;
    return $text if $_;
    return;
};
1;
