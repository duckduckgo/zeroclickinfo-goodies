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

triggers start => 'crontab', 'cron', 'cronjob';

zci is_cached => 0;

primary_example_queries   'crontab * */3 * * *';
=comment
                                    * */3 * * *
                                    * * * * * *
                                    | | | | | | 
                                    | | | | | +-- Year              (range: 1900-3000)
                                    | | | | +---- Day of the Week   (range: 1-7, 1 standing for Monday)
                                    | | | +------ Month of the Year (range: 1-12)
                                    | | +-------- Day of the Month  (range: 1-31)
                                    | +---------- Hour              (range: 0-23)
                                    +------------ Minute            (range: 0-59)
=cut
secondary_example_queries 'crontab 42 12 3 Feb Sat';
description               'show the next occurance of a cron job in human-readable form';
name                      'ParseCron';
code_url                  'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ParseCron.pm';
category                  'computing_info';
topics                    'sysadmin';
attribution               web     => [ 'http://indeliblestamp.com', 'Arun S' ],
                          github  => [ 'http://github.com/indeliblestamp', 'IndelibleStamp' ] ;

handle remainder => sub {
    my $crontab = $_;
    
    # We replace Jan,Feb.. and Mon,Tue.. with 1,2..
    foreach (0 .. $#mon) {
	    my $newmonth = $_ + 1;
	    $crontab =~ s/$mon[$_]/$newmonth/;
    }

    foreach (0 .. $#day) {
	    my $newday = $_ + 1;
	    $crontab =~ s/$day[$_]/$newday/;
    }

    print STDERR 'CRONTAB', "\n", $crontab, "\n"; 
    my $cron = Schedule::Cron::Events->new($crontab) or return;
    print STDERR 'CRON', "\n", $cron, "\n";
    use Data::Dumper; print STDERR Dumper($cron);
    my $text;
    
    # Fix for issue #95: Show the next 3 events instead of just one.
    for (my $count = 1; $count <= 10; $count++) {
        my ($sec, $min, $hour, $day, $month, $year) = $cron->nextEvent;
        
        $text .= sprintf("%2d:%02d:%02d on %d %s, %d\n", $hour, $min, $sec, $day, $mon[$month], ($year+1900));
    }
    print STDERR 'TEXT', "\n", $text, "\n";
    return "Cron will schedule the job at this frequency: \n$text";
    return;
};



1;
