package DDG::Goodie::ParseCron;
# ABSTRACT: Parsing Crontabs - Show next occurence of cron event in human-readable form.
# Example input:
#     crontab 42 12 3 Feb Sat
# Example output:
#     Event will start next at 12:42:00 on 2 Feb, 2013
#

use DDG::Goodie;
use Schedule::Cron::Events;
use List::MoreUtils qw(firstidx);

my @mon = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my @day = qw(Sun Mon Tue Wed Thu Fri Sat);

triggers start => 'crontab', 'cron', 'cronjob';

zci is_cached => 0;

primary_example_queries 'crontab * */3 * * *';
secondary_example_queries 'crontab 42 12 3 Feb Sat';
description 'show the next occurrence of a cron job in human-readable form';
name 'ParseCron';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ParseCron.pm';
category 'computing_info';
topics 'sysadmin';
attribution web     => [ 'http://indeliblestamp.com', 'Arun S' ],
            github  => [ 'http://github.com/indeliblestamp', 'IndelibleStamp' ] ;

handle remainder => sub {
    my $input = $_;

    my @crontab = split( ' ', $input );

    if( $crontab[3] ne '*' ) {
        # Month value ranges 1-12.
        $crontab[3] = ( firstidx{ $_ eq ucfirst $crontab[3] } @mon ) + 1;
    }

    if( $crontab[4] ne '*' ) {
        # Day of Week value ranges 0-6, * 0 is Sunday
        $crontab[4] = ( firstidx{ $_ eq ucfirst $crontab[4] } @day );
    }

    my $crontab_str = join( ' ', @crontab );

    my $cron = Schedule::Cron::Events->new($crontab_str) or return;

    my $text;
    # Fix for issue #95: Show the next 3 events instead of just one.
    for (my $count=1;$count<=3;$count++) {
      my ($sec, $min, $hour, $day, $month, $year) = $cron->nextEvent;
      $text .= sprintf("%2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));
    }
    return "Cron will schedule the job at this frequency: \n$text" if $_;
    return;
};
1;
