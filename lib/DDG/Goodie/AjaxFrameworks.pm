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

    my ($lang, @lang_frameworks, @frameworks_list, $title);

    # Remove keywords 'framework' and 'frameworks' from the remainder
    #
    # Useful for queries like 'ajax javascript frameworks'
    # Remainder in such cases is 'javascript frameworks'
    $_ =~ s/(frameworks|framework)//g;

    trim($_);  # Trim

    # Return if the remainder is empty after above operations
    return unless $_;

    # Return if the remainder doesn't match supported languages
    return if $_ !~ /^(javascript|js|perl|php|python|py|java|ruby)$/i;

    $lang = $_;

    # Handle queries for 'js' instead of 'javascript'
    $lang = "javascript"
        if $lang eq "js";

    # Handle queries for 'py' instead of 'python'
    $lang = "python"
        if $lang eq "py";

    @lang_frameworks = $DATA->{$lang};
    @frameworks_list = @{$lang_frameworks[0]};

    $title = "List of frameworks for implementation of Ajax using '$lang' language";

    return $title,
        structured_answer => {

            data => {
                title => $title,
                list => \@frameworks_list
            },

            templates => {
                group => "list",
                options => {
                    list_content => "DDH.ajax_frameworks.list_content"
                }
            }
        };
};

1;
