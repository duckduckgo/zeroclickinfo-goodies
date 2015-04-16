package DDG::Goodie::LoremIpsum;
# ABSTRACT: Lorem Ipsum Generator

use DDG::Goodie;
use Text::Lorem;
zci answer_type => "lorem_ipsum";
zci is_cached   => 1;

name "LoremIpsum";
description "Generates Lorem Ipsum text";
primary_example_queries "lorem ipsum", "lipsum", "lorem ipsum 6";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/LoremIpsum.pm";
attribution github => ["https://github.com/jee1mr", "Jeevan M R"],
            twitter => ["https://twitter.com/jee1mr","Jeevan M R"];


triggers startend => "lorem ipsum", "lipsum";
my $text = Text::Lorem->new();

handle remainder => sub {
    my $loop = 4;
    $loop = $_ if $_ && $_ =~ /(^\d+$)/;
    $loop = 10 if $loop > 10;

    my @lorem;
    map { push (@lorem, $text->paragraphs(1)) } (1..$loop);

    my $plaintext = join " ", @lorem;

    return $plaintext,
    structured_answer => {
        id => 'lorem_ipsum',
        name => 'Answer',
        data => {
            title => 'Lorem Ipsum',
            subtitle => "$loop Random Paragraphs",
            lorem_array => \@lorem,
        },
        meta => {
            sourceName => "Lipsum",
            sourceUrl => "http://lipsum.com/"
        },
        templates => {
            group => 'text',
            options =>{
                content => 'DDH.lorem_ipsum.content',
                moreAt => 1
            }
        }
    };
};

1;