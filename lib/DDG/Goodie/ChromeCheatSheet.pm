package DDG::Goodie::ChromeCheatSheet;
# ABSTRACT: Provide a cheatsheet for Google Chrome keyboard shortcuts

use DDG::Goodie;

zci answer_type => 'chrome_cheat';
zci is_cached   => 1;

name "ChromeCheatSheet";
source "http://chromecheat.blogspot.com/";
description "Chrome cheat sheet";
category "cheat_sheets";
topics "programming", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ChromeCheatSheet.pm";

primary_example_queries 'chrome shortcuts', 'chrome cheat sheet', 'chrome keyboard shortcuts';
secondary_example_queries 'google chrome keyboard shortcuts', 'chrome reference';

triggers startend => (
    'chrome cheat sheet',
    'chrome cheatsheet',
    'google chrome cheat sheet',
    'help chrome',
    'chrome reference',
    'cheat sheet chrome',
    'cheatsheet chrome',
    'cheat sheet google chrome',
    'cheatsheet google chrome',
    'chrome shortcuts',
    'google chrome shortcuts',
    'goodle chrome keyboard shortcuts',
    'chrome help',
);

attribution github  => ["nickcalabs",            "Nick Calabro"],
            twitter => ["nickcalabs",           "Nick Calabro"],
            web     => ["http://nickcalabro.com", "Nick Calabro"];

handle remainder => sub {
    return
        heading => 'Chrome Cheat Sheet',
        html    => html_cheat_sheet(),
        answer   => text_cheat_sheet(),
};

my $HTML;

sub html_cheat_sheet {
    $HTML //= share("chrome_cheat_sheet.html")
        ->slurp(iomode => '<:encoding(UTF-8)');
    return $HTML;
}

my $TEXT;

sub text_cheat_sheet {
    $TEXT //= share("chrome_cheat_sheet.txt")
        ->slurp(iomode => '<:encoding(UTF-8)');
    return $TEXT;
}

1;
