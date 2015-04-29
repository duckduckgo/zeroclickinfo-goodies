#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "lorem_ipsum";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::LoremIpsum )],
    'lorem ipsssum 3' => undef,
    'lorem dipsum' => undef,
    'lipsum 10' => test_zci(
        qr/[a-zA-Z .]+/,
        make_structured_answer(10)
    )

);

sub make_structured_answer {
    my ($loop) = @_;
    my $pattern = qr/[a-zA-Z \.\n]*/;
    my @lorem_array = ($pattern) x $loop; 

    return structured_answer => {
        id => 'lorem_ipsum',
        name => 'Answer',
        data => {
            title => "Lorem Ipsum",
            subtitle => "$loop Random Paragraph",
            lorem_array => \@lorem_array,
        },
         meta => {
            sourceName => "Lipsum",
            sourceUrl => "http://lipsum.com/"
        },
        templates => {
            group => 'text',
            options => {
                content => 'DDH.lorem_ipsum.content',
                moreAt => 1
            }
        }
    };
};

done_testing;
