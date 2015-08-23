package DDG::Goodie::TodoistCheatSheet;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "todoist_cheat_sheet";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "TodoistCheatSheet";
description "A cheat sheet for using Todoist";
primary_example_queries "todoist cheat sheet";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/TodoistCheatSheet.pm";
attribution github => ["alexander95015", "Alexander"],
            web => ['http://www.alexnext.com', 'Alexander'],
            facebook => ['alexander95015','Alexander Huang']
            twitter => "alexander95015";

# Triggers
triggers any => "todoist cheat sheet";

# Handle statement
handle remainder => sub {

    # optional - regex guard
    # return unless qr/^\w+/;

    return unless $_; # Guard against "no answer"

    return $_;
};

1;
