package DDG::Goodie::ReadlineCheatSheet;
# ABSTRACT: Provide a cheatsheet for readline shortcuts

use DDG::Goodie;

zci answer_type => "readline_cheat";

name "ReadlineCheatSheet";
description "Readline cheat sheet";
source "https://github.com/kablamo/readline-cheat-sheet";
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/ReadlineCheatSheet.pm";
category "cheat_sheets";
topics "computing", "geek", "programming", "sysadmin";

primary_example_queries 'readline help', 'readline cheat sheet', 'readline commands';
secondary_example_queries 'bash quick reference', 'bash commands', 'bash guide';

triggers startend => (
    'read line cheat sheet', 
    'read line cheatsheet', 
    'read line commands',
    'read line guide',
    'read line help',
    'read line quick reference',
    'read line reference',
    'readline cheat sheet', 
    'readline cheatsheet', 
    'readline commands',
    'readline guide',
    'readline help',
    'readline quick reference',
    'readline reference',
    'bash cheat sheet', 
    'bash cheatsheet', 
    'bash commands',
    'bash guide',
    'bash help',
    'bash quick reference',
    'bash reference',
);

attribution github  => ["kablamo",            "Eric Johnson"],
            twitter => ["kablamo_",           "Eric Johnson"],
            web     => ["http://kablamo.org", "Eric Johnson"];

handle remainder => sub {
    my $query     = $_;
    my $edit_mode = $query =~ /vim?/i ? 'Vi' : 'Emacs';

    return 
        heading => "Readline Cheat Sheet ($edit_mode Mode)",
        html    => html($edit_mode),
        answer  => text($edit_mode);
};

my %HTML;

sub html {
    my $edit_mode = lc shift;

    return $HTML{$edit_mode} if $HTML{$edit_mode};

    $HTML{$edit_mode} = share("${edit_mode}_cheat_sheet.html")
        ->slurp(iomode => '<:encoding(UTF-8)');

    return $HTML{$edit_mode};
}

my %TEXT;

sub text {
    my $edit_mode = lc shift;

    return $TEXT{$edit_mode} if $TEXT{$edit_mode};

    $TEXT{$edit_mode} = share("${edit_mode}_cheat_sheet.txt")
        ->slurp(iomode => '<:encoding(UTF-8)');

    return $TEXT{$edit_mode};
}

1;
