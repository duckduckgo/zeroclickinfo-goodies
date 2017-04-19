package DDG::Goodie::FirefoxAwesomeBarCheatSheet;
# ABSTRACT: Cheat Sheet for using the Firefox Awesome Bar

use DDG::Goodie;
use strict;

zci answer_type => "firefox_awesome_bar_cheat_sheet";
zci is_cached   => 1;

name "FirefoxAwesomeBarCheatSheet";
description "Cheat Sheet for using the Firefox Awesome Bar";
source "https://support.mozilla.org/en-US/kb/awesome-bar-keyboard-shortcuts";

primary_example_queries "firefox awesome bar cheatsheet", "firefox awesome bar cheat sheet",
                        "firefox awesome bar commands", "firefox awesome bar help";
secondary_example_queries "firefox awesome bar reference", "firefox awesome bar guide",
                          "firefox awesome bar quick reference";

category "cheat_sheets";
topics "geek", "computing";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FirefoxAwesomeBarCheatSheet.pm";
attribution github => ["https://github.com/domjacko", "domjacko"],
            twitter => "domjacko";

# Triggers
triggers startend => "firefox awesome bar cheatsheet", 
                     "firefox awesome bar cheat sheet",
                     "firefox awesome bar help", 
                     "firefox awesome bar commands", 
                     "firefox awesome bar guide",
                     "firefox awesome bar reference", 
                     "firefox awesome bar quick reference",
                     "cheatsheet firefox awesome bar",
                     "cheat sheet firefox awesome bar",
                     "help firefox awesome bar",
                     "commands firefox awesome bar",
                     "guide firefox awesome bar", 
                     "reference firefox awesome bar", 
                     "quick reference firefox awesome bar";


my $TEXT = scalar share('firefox_awesome_bar_cheat_sheet.txt')->slurp,
my $HTML = scalar share('firefox_awesome_bar_cheat_sheet.html')->slurp;

# Handle statement
handle remainder => sub {
    return 
        heading => 'Firefox Awesome Bar Cheat Sheet',
        answer  => $TEXT,
        html    => $HTML,
};

1;
