use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'lorem_ipsum';
zci is_cached => 0;

sub build_result {
    my $result = shift;
    return $result, structured_answer => {
        id   => 'lorem_ipsum',
        name => 'Answer',
        data => "-ANY-",
        meta => {
            sourceName => "Lipsum",
            sourceUrl  => "http://lipsum.com/"
        },
        templates => {
            group   => 'info',
            options => {
                moreAt       => 1,
                content      => 'DDH.lorem_ipsum.content',
                chompContent => 1,
            }
        }
    };
};


sub build_test { test_zci(build_result(qr/^$_[0]$/)) }

my $word = qr/[a-z]+/i;
my $line_end     = qr/[?!.]/;

sub separated {
    my ($sep) = shift;
    return sub {
        my ($reg, $end, $amount) = @_;
        return qr/($reg$sep){@{[$amount - 1]}}$reg$end/;
    };
}
sub arby_sep {
    my $sep = shift;
    return sub {
        my ($reg, $end) = @_;
        return qr/($reg$sep)*$reg$end/;
    };
}

*spaced = separated qr/ /;
*arby_spaced = arby_sep qr/ /;
*lined  = separated qr/\n\n/;
sub sentence  { arby_spaced($word, qr/\./) };
sub paragraph { arby_spaced(sentence(), qr//) };
sub sentences { spaced(sentence(), qr//, $_[0]) }
sub words { return spaced($word, qr//, $_[0]) };
sub paragraphs { lined(paragraph(), qr//, $_[0]) }

ddg_goodie_test(
    [qw( DDG::Goodie::LoremIpsum )],
    # First form
    '5 words of lorem ipsum'        => build_test(words(5)),
    'a word of lipsum'              => build_test(words(1)),
    'sentence of lorem ipsum'       => build_test(sentence()),
    '3 words of utter lipsum'       => build_test(words(3)),
    '2 words of random lorem ipsum' => build_test(words(2)),
    'seven words of lorem ipsum'    => build_test(words(7)),
    '1 line of regular lipsum'      => build_test(sentences(1)),
    # Second form
    '3 lipsum words'               => build_test(words(3)),
    '7 random latin paragraphs'    => build_test(paragraphs(7)),
    'two random latin sentences'   => build_test(sentences(2)),
    'three lorem ipsum paragraphs' => build_test(paragraphs(3)),
    # Third form
    'lorem ipsum' => build_test(paragraphs(5)),
    'lipsum'      => build_test(paragraphs(5)),
    'latin'       => undef,
    # Non-matchers
    'utter latin'                         => undef,
    'lipsum word'                         => undef,
    'what is a word of lorem ipsum'       => undef,
    'three french hens and a lipsum word' => undef,
);


done_testing;
