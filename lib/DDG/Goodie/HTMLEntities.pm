package DDG::Goodie::HTMLEntities;
# ABSTRACT: Write an abstract here

use DDG::Goodie;
use strict;
use warnings;

use JSON::MaybeXS;

zci answer_type => 'html_entities';
zci is_cached => 1;

triggers any => 'html entities table';

handle remainder => sub {

    open(my $fh, "<", "share/goodie/htmlentities/entities.json") or return;

    my $json = do { local $/;  <$fh> };
    my $table = decode_json($json) or return;

    return 'htmlentities', structured_answer => {
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
                content => 'DDH.htmlentities.content',
                moreAt => 1
            }
        }
    };
};

1;
