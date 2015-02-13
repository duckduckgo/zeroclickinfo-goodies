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


triggers any => "lorem ipsum", "lipsum";
my $text = Text::Lorem->new();
handle remainder => sub {
    return $text->paragraphs($_) if $_ && $_ =~ /(^\d{1}$)|10/; 
    return $text->paragraphs(4);
};

1;
