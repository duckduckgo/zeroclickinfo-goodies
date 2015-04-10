package DDG::Goodie::BlenderCheatSheet;
# ABSTRACT: Provide a cheatsheet for common Blender shortcuts
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "blender_cheat_sheet";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "BlenderCheatSheet";
description "Blender most common shortcuts";
primary_example_queries "blender shortcuts", "blender key bindings";
# secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
category "cheat_sheets";
topics "computing", "geek", "special_interest";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/BlenderCheatSheet.pm";
attribution github => ["xuv", "Julien Deswaef"],
            twitter => "xuv";

# Triggers
triggers any => "blender help", "blender shortcuts", "blender cheat sheet", "blender cheatsheet", "blender key bindings", "blender guide", "shortcut blender", "shortcuts blender", "cheatsheet blender", "cheat sheet blender", "key bindings blender", "keybindings blender", "blender keybindings", "guide blender", "help blender";

my $HTML = share("blender_cheat_sheet.html")->slurp(iomode => "<:encoding(UTF-8)");
my $TEXT = share("blender_cheat_sheet.txt")->slurp(iomode => "<:encoding(UTF-8)");;

handle remainder => sub {
    return
        heading => "Blender Cheat Sheet",
        html    => $HTML,
        answer  => $TEXT,
};

1;
