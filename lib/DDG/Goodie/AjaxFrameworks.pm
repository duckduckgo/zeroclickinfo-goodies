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

    my ($lang, @lang_frameworks);

    # Remove keywords 'framework' and 'frameworks' from the remainder
    #
    # Useful for queries like 'ajax javascript frameworks'
    # Remainder in such cases is 'javascript frameworks'
    $_ =~ s/(frameworks|framework)//g;

    trim($_);  # Trim

    # Return if the remainder is empty after above operations
    return unless $_;

    # Return if the remainder doesn't match supported languages
    return if $_ !~ /^(javascript|js|perl|php|python|java|ruby)$/i;

    $lang = $_;
    if ($lang eq "js") {
        $lang = "javascript";
    }

    print $lang;
    @lang_frameworks = $DATA->{$lang};

    return "plain text response",
        structured_answer => {

            data => {
                title => "List of famous frameworks for implementation of Ajax using $lang language:",
                list => \@lang_frameworks
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
