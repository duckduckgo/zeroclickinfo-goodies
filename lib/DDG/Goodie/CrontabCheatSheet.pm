package DDG::Goodie::CrontabCheatSheet;
# ABSTRACT: Some examples of crontab syntax

use strict;
use DDG::Goodie;

zci answer_type => "cron_cheat";
zci is_cached   => 1;

triggers startend => (
    'cron cheat sheet',
    'cron cheatsheet',
    'cron guide',
    'cron help',
    'cron quick reference',
    'cron reference',
    'cron example',
    'cron examples',
    'crontab cheat sheet',
    'crontab cheatsheet',
    'crontab guide',
    'crontab help',
    'crontab quick reference',
    'crontab reference',
    'crontab example',
    'crontab examples'
);

my $HTML = share("crontab_cheat_sheet.html")->slurp(iomode => '<:encoding(UTF-8)');
my $TEXT = share("crontab_cheat_sheet.txt")->slurp(iomode => '<:encoding(UTF-8)');

handle remainder => sub {
    return
        heading => 'Cron Cheat Sheet',
        html    => $HTML,
        answer  => $TEXT,
};

1;
