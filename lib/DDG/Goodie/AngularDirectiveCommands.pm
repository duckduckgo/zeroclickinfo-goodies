package DDG::Goodie::AngularDirectiveCommands;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "angular_directive_commands";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "AngularDirectiveCommands";
source "https://docs.angularjs.org/api/ng/directive";
description "Angular Js directives commands for reference to the developers to use it in their  application";
primary_example_queries "angular cheat sheet", "angular commands,angular command";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
 category "reference";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
 topics "programming","computing";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/AngularDirectiveCommands.pm";
attribution github => ["SibuStephen", "sibu Stephen"],
            twitter =>"sibustephen";

# Triggers
triggers any => "duckduckhack", "sibu stephen";

# Handle statement
handle remainder => sub {

    # optional - regex guard
    # return unless qr/^\w+/;

   

    return "sibu stephen suggested this feature";
};};

1;
