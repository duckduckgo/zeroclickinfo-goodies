use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'gibberish_generator';
zci is_cached => 0;

sub build_result {
    my $result = shift;
    return $result, structured_answer => {
        id   => 'gibberishgenerator',
        name => 'Answer',
        data => '-ANY-',
        templates  => {
            group  => 'text',
            moreAt => 0,
        },
    };
}


sub build_test { test_zci(build_result(qr/^$_[0]$/)) }

my $shake_word   = qr/[a-z'-]+/i;
my $french_word  = qr/[a-zàâæçéèêëîïôœùûüÿ]+/i;
my $english_word = qr/[a-z]+/i;
my $swedish_word = qr/[a-zåäö]+/i;
my $german_word  = qr/[a-zäöüß]+/i;

sub spaced {
    my ($reg, $end, $amount) = @_;
    return qr/($reg ){@{[$amount - 1]}}$reg$end/;
}
sub sentence  { qr/($_[0] )+$_[0]\./ }
sub werds     { spaced($_[0], qr/\./, $_[1]) }
sub paragraph { spaced(sentence($_[0]), qr//, $_[1]) }

ddg_goodie_test(
    [qw( DDG::Goodie::GibberishGenerator )],
    # First form
    '5 words of gibberish'                    => build_test(werds($english_word, 5)),
    'sentence of nonsense'                    => build_test(sentence($english_word)),
    '3 words of utter Shakespearean nonsense' => build_test(werds($shake_word, 3)),
    '2 words of french gibberish'             => build_test(werds($french_word, 2)),
    # Second form
    '3 nonsense words'               => build_test(werds($english_word, 3)),
    '7 Swedish nonsense words'       => build_test(werds($swedish_word, 7)),
    # Non-matchers
    'utter nonsense'                        => undef,
    'nonsense word'                         => undef,
    'what is a word of nonsense'            => undef,
    'three french hens and a nonsense word' => undef,
);

done_testing;
