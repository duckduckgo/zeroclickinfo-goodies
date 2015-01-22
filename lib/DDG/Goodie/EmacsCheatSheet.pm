package DDG::Goodie::EmacsCheatSheet;
# ABSTRACT: A cheatsheet for useful emacs commands

use DDG::Goodie;

zci answer_type => "emacs_cheat_sheet";
zci is_cached   => 1;

name "EmacsCheatSheet";
description "emacs cheatsheet";
source "http://www.rgrjr.com/emacs/emacs_cheat.html";

category "cheat_sheets";
topics "computing", "geek", "programming", "sysadmin";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EmacsCheatSheet.pm";
attribution github  => ["https://github.com/jim-brighter", "Jim Brighter"],
            twitter => "jim_brighter";

primary_example_queries "emacs cheatsheet", "emacs cheat sheet", "emacs commands", "emacs help";
secondary_example_queries "emacs reference", "emacs guide", "emacs quick reference";

triggers startend => "emacs cheatsheet", "emacs cheat sheet",
                     "emacs help", "emacs commands", "emacs guide",
                     "emacs reference", "emacs quick reference";

handle remainder => sub {
	return 
        heading => 'Emacs Cheat Sheet',
        answer  => text_cheat_sheet(),
        html    => html_cheat_sheet(),
};

my $HTML;

sub html_cheat_sheet {
    $HTML //= share("emacs_cheat_sheet.html")
            ->slurp(iomode => '<:encoding(UTF-8)');
        return $HTML;
}

my $TEXT;

sub text_cheat_sheet {
    $TEXT //= share("emacs_cheat_sheet.txt")
            ->slurp(iomode => '<:encoding(UTF-8)');
        return $TEXT
}

1;
