package DDG::Goodie::LoremIpsum;
# ABSTRACT: generates random latin

use strict;
use DDG::Goodie;
use utf8;

use Text::Lorem::More;
use Lingua::EN::Numericalize;

triggers any => 'lorem ipsum', 'lipsum', 'latin';

zci is_cached => 0;
zci answer_type => 'lorem_ipsum';

handle query_lc => sub {
    my $query   = $_;
    # Treat 'a' as 'one' for the purposes of amounts.
    $query =~ s/line/sentence/g;
    my $default = 0;
    my $result = '';
    my $amount = 0;
    my $formatted_input;
    if ($query =~ /^\s*l(orem )?ipsum\s*$/) {
        $default = 1;
        $result = Text::Lorem::More->paragraphs(4);
    } else {
        ($result, $formatted_input) = get_result_and_formatted($query) or return;
    };

    return $result, structured_answer => {
        id   => 'lorem_ipsum',
        name => 'Answer',
        data => {
            description => "$result",
            is_default  => $default,
            title       => ' ',
            subtitle    => "$formatted_input",
        },
        meta => {
            sourceName => "Lipsum",
            sourceUrl  => "http://lipsum.com/"
        },
        templates => {
            group => 'info',
            options => {
                moreAt => 1
            }
        }
    };
};

1;
