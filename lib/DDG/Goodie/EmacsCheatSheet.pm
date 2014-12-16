package DDG::Goodie::EmacsCheatSheet;
# ABSTRACT: A cheatsheet for useful emacs commands

use DDG::Goodie;

zci answer_type => "emacs_cheat_sheet";
zci is_cached   => 1;

name "EmacsCheatSheet";
description "emacs cheatsheet";
source "ADD SOURCE";
primary_example_queries "emacs cheatsheet", "emacs commands", "emacs help";
secondary_example_queries "emacs reference", "emacs guide";
category "cheat_sheets";
topics "computing", "geek", "programming", "sysadmin";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EmacsCheatSheet.pm";
attribution github => ["https://github.com/jim-brighter", "Jim Brighter"],
            twitter => "jim_brighter";

triggers startend => "emacs cheatsheet", "emacs cheat sheet",
                     "emacs help", "emacs commands", "emacs guide",
                     "emacs reference", "emacs quick reference";

handle remainder => sub {

	return unless $_; # Guard against "no answer"

	return $_;
};

1;
