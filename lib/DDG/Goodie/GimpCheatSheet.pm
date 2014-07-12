package DDG::Goodie::GimpCheatSheet;
# ABSTRACT: Some GIMP keyboard and mouse shortcuts

# Adapted from CrontabCheatSheet.pm

use DDG::Goodie;

zci answer_type => "gimp_cheat";

name "GimpCheatSheet";
description "GIMP shortcut cheat sheet";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GimpCheatSheet.pm";
category "cheat_sheets";
topics "computing";

primary_example_queries "gimp help", "gimp cheat sheet", "gimp shortcuts";

triggers startend => (
    "gimp cheat sheet", 
    "gimp cheatsheet", 
    "gimp help",
    "gimp quick reference",
    "gimp reference",
    "gimp shortcut",
    "gimp shortcuts"
);

attribution github  => ["elebow", "Eddie Lebow"];

handle remainder => sub {
    return 
        heading => "GIMP Shortcut Cheat Sheet",
        html    => html_cheat_sheet(),
        answer  => text_cheat_sheet(),
};

my $HTML;

sub html_cheat_sheet {
    $HTML //= share("gimp_cheat_sheet.html")
        ->slurp(iomode => "<:encoding(UTF-8)");
    return $HTML;
}

my $TEXT;

sub text_cheat_sheet {
    $TEXT //= share("gimp_cheat_sheet.txt")
        ->slurp(iomode => "<:encoding(UTF-8)");
    return $TEXT;
}

1;

