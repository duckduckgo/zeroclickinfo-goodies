package DDG::Goodie::BlenderCheatSheet;
# ABSTRACT: Provide a cheatsheet for common Blender shortcuts
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "blender_cheat_sheet";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "BlenderCheatSheet";
description "Blender most common shortucts";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
category "cheat_sheets";
topics "computing", "geek", "special_interest";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/BlenderCheatSheet.pm";
attribution github => ["xuv", "Julien Deswaef"],
            twitter => "xuv";

# Triggers
triggers any => "blender help", "blender shortcuts", "blender cheat sheet", "blender key bindings";

# Handle statement
handle remainder => sub {

    # optional - regex guard
    # return unless qr/^\w+/;

    return unless $_; # Guard against "no answer"

    return $_;
};

1;
