package DDG::Goodie::<: $ia_package_name :>;
# ABSTRACT: Write an abstract here

# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => '<: $ia_id :>';

# Caching - https://duck.co/duckduckhack/spice_advanced_backend#caching-api-responses
zci is_cached => 1;

# Triggers - https://duck.co/duckduckhack/goodie_triggers
triggers <: $ia_trigger :>;

# Handle statement
handle <: $ia_handler :> => sub {

    return 'plain text response',
        structured_answer => {

            data => {
                <: $ia_handler :> => \<: $ia_handler_var :>_,
            },

            templates => {
                group => 'text',
                # options => {
                #
                # }
            }
        };
};

1;
