package DDG::Goodie::AjaxFrameworks;
# ABSTRACT: Return a list of Ajax frameworks for a given language

use DDG::Goodie;
use YAML::XS 'LoadFile';
use Text::Trim;

use strict;

zci answer_type => 'ajax_frameworks';
zci is_cached => 1;

triggers any => 'ajax';

my $DATA = LoadFile(share('frameworks.yml'));

# Handle statement
handle remainder => sub {

    my ($lang, @lang_frameworks, @frameworks_list, $title);

    # Return if the remainder doesn't contain the keyword 'framework'
    return unless $_ =~ /framework/i;

    # Remove keywords 'framework' and 'frameworks' from the remainder
    #
    # Useful for queries like 'ajax javascript frameworks'
    # Remainder in such cases is 'javascript frameworks'
    $_ =~ s/(frameworks|framework)//gi;

    trim($_);  # Trim

    # Return if the remainder is empty after above operations
    return unless $_;

    # Return if the remainder doesn't match supported languages
    return if $_ !~ /^(javascript|js|perl|php|python|py|java|ruby)$/i;

    $lang = lc $_;

    # Handle queries for 'js' instead of 'javascript'
    $lang = "javascript"
        if $lang eq "js";

    # Handle queries for 'py' instead of 'python'
    $lang = "python"
        if $lang eq "py";

    @lang_frameworks = $DATA->{$lang};
    @frameworks_list = @{$lang_frameworks[0]};

    # Return if the fetched list has no data to show
    return unless (@frameworks_list);

    $title = "Frameworks";
    $title = "Framework"
        if (scalar @frameworks_list == 1);
    $title .= " for implementation of Ajax using '$lang'";

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
            },

            meta => {
                sourceName => "Wikipedia",
                sourceUrl => "https://en.wikipedia.org/wiki/List_of_Ajax_frameworks"
            }
        };
};

1;
