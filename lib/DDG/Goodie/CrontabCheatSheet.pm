package DDG::Goodie::CrontabCheatSheet;
# ABSTRACT: Some examples of crontab syntax

# Adapted from VimCheatSheet.pm

use DDG::Goodie;

zci answer_type => "cron_cheat";

name "CrontabCheatSheet";
description "Crontab cheat sheet";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CrontabCheatSheet.pm";
category "cheat_sheets";
topics "computing", "geek", "programming", "sysadmin";

primary_example_queries 'crontab help', 'crontab cheat sheet', 'crontab example';

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

attribution github  => ["nkorth", "Nathan Korth"];

handle remainder => sub {
    return 
        heading => 'Cron Cheat Sheet',
        html    => html_cheat_sheet(),
        answer  => text_cheat_sheet(),
};

my $HTML;

sub html_cheat_sheet {
    $HTML //= share("crontab_cheat_sheet.html")
        ->slurp(iomode => '<:encoding(UTF-8)');
    return $HTML;
}

my $TEXT;

sub text_cheat_sheet {
    $TEXT //= share("crontab_cheat_sheet.txt")
        ->slurp(iomode => '<:encoding(UTF-8)');
    return $TEXT;
}

1;
