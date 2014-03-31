package DDG::Goodie::ParseCron;
# ABSTRACT: Parsing Crontabs - Show next occurence of cron event in human-readable form.

use DDG::Goodie;

use ParseCron qw/parse_cron/;

triggers start => 'crontab', 'cron', 'cronjob';

zci is_cached  => 0;

primary_example_queries   'crontab * */3 * * *';
secondary_example_queries 'crontab 42 12 3 Feb Sat';
description               'describe a cron job in human-readable form';
name                      'ParseCron';
code_url                  'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ParseCron.pm';
category                  'computing_info';
topics                    'sysadmin';
attribution               web     => [ 'http://indeliblestamp.com', 'Arun S' ],
                          github  => [ 'http://github.com/indeliblestamp', 'IndelibleStamp' ] ;

handle remainder => sub {
    my $result = parse_cron($_);

    return if !$result;

    return if $result =~ /error/i;

    return "($_) means this cron job will run:$result";
};



1;
