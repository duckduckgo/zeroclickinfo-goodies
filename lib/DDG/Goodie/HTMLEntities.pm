package DDG::Goodie::HtmlEntities;

# ABSTRACT:  This goodie loads a static table of HTML entities.

use DDG::Goodie;
use strict;
use warnings;
use YAML::XS 'LoadFile';

zci answer_type => 'html_entities';
zci is_cached => 1;

triggers startend => 'html entities';

my $table = LoadFile(share('entities.yml'));

handle query_lc => sub {

    return unless m/^(list of )?html entities( table| list)?$/;

    return 'HTML Entities', structured_answer => {
        data => {
            title => "HTML Entities",
            table => $table
        },
        meta => {
            sourceName => "W3.org",
            sourceUrl => "https://dev.w3.org/html5/html-author/charref"
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.html_entities.content',
                moreAt => 1
            }
        }
    };
};

1;
