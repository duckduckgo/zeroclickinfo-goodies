package DDG::Goodie::UrlEscapeCodes;
# ABSTRACT: Shows URL Escape Codes

use DDG::Goodie;
use YAML::XS 'LoadFile';
use strict;
use warnings;

zci answer_type => 'url_escape_codes';

zci is_cached => 1;

triggers start => 'url escape', 'url escaping', 'url escape codes', 'url escape characters',
                  'url escape sequences';

my $url_escape_codes = LoadFile(share('data.yml'));

handle remainder => sub {
    return unless $_ eq '';

    return '',
        structured_answer => {
            id => 'url_escape_codes',
            name => 'URL Escape Codes',
            data => {
                title => 'URL Escape Codes',
                table => $url_escape_codes
            },
            meta => {
                sourceName => 'december.com',
                sourceUrl => 'http://www.december.com/html/spec/esccodes.html'
            },
            templates => {
                group => 'list',
                item => 0,
                options => {
                    content => 'DDH.url_escape_codes.content',
                    moreAt => 1
                }
            }
        };
};

1;
