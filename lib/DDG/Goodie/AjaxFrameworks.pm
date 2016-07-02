package DDG::Goodie::AjaxFrameworks;
# ABSTRACT: Return a list of Ajax frameworks for a given language

use DDG::Goodie;
use YAML::XS 'LoadFile';
use Text::Trim;

use strict;

zci answer_type => 'ajax_frameworks';
zci is_cached => 1;

triggers any => 'ajax', 'ajax framework', 'ajax frameworks';

my $DATA = LoadFile(share('frameworks.yml'));

# Handle statement
handle remainder => sub {

    # Remove keywords 'framework' and 'frameworks' from the remainder
    #
    # Useful for queries like 'ajax javascript frameworks'
    # Remainder in such cases is 'javascript frameworks'
    $_ =~ s/(frameworks|framework)//g;
    trim($_);  # Trim
    print $_;

    # Return if the remainder is empty after above operations
    return unless $_;

    # Return if the remainder doesn't match supported languages
    return if $_ !~ /^(javascript|js|perl|php|python|java|ruby)$/i;

    return "plain text response",
        structured_answer => {

            data => {
                title    => "My Instant Answer Title",
                subtitle => "My Subtitle",
                # image => "http://website.com/image.png",
            },

            templates => {
                group => "text",
                # options => {
                #
                # }
            }
        };
};

1;
