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
        id   => 'gibberish_generator',
        name => 'Answer',
        data => "-ANY-",
        templates => {
            group   => 'info',
            options => {
                moreAt       => 0,
                content      => 'DDH.gibberish_generator.content',
                chompContent => 1,
            }
        }
    };
}


sub build_test { test_zci(build_result(qr/^$_[0]$/)) }

my $shake_word   = qr/[a-z'-]+/i;
my $french_word  = qr/[a-zàâæçéèêëîïôœùûüÿ'-]+/i;
my $english_word = qr/[a-z'-]+/i;
my $swedish_word = qr/[a-zåäöé-]+/i;
my $german_word  = qr/[a-zäöüß]+/i;
my $line_end     = qr/[?!.]/;

sub separated {
    my ($sep) = shift;
    return sub {
        my ($reg, $end, $amount) = @_;
        $amount--;
        return qr/($reg$sep){$amount}$reg$end/;
    };
}
*spaced = separated qr/ /;
*lined  = separated qr/\n/;
sub sentence  { qr/($_[0] )+$_[0]\./ }
sub line      { qr/($_[0] )+$_[0]$line_end/ }
sub werds     { spaced($_[0], qr/\./, $_[1]) }
sub paragraph { spaced(sentence($_[0]), qr//, $_[1]) }
sub line_para { lined(line($_[0]), qr//, $_[1]) }

ddg_goodie_test(
    [qw( DDG::Goodie::GibberishGenerator )],
    # First form
    '5 words of gibberish'                    => build_test(werds($english_word, 5)),
    'a word of gibberish'                     => build_test(werds($english_word, 1)),
    'sentence of nonsense'                    => build_test(sentence($english_word)),
    '3 words of utter Shakespearean nonsense' => build_test(werds($shake_word, 3)),
    '2 words of french gibberish'             => build_test(werds($french_word, 2)),
    'seven words of german nonsense'          => build_test(werds($german_word, 7)),
    '1 line of shakespearean gibberish'       => build_test(line_para($shake_word, 1)),
    # Second form
    '3 nonsense words'               => build_test(werds($english_word, 3)),
    '7 Swedish nonsense words'       => build_test(werds($swedish_word, 7)),
    'two swedish nonsense sentences' => build_test(paragraph($swedish_word, 2)),
    'three gibberish lines'          => build_test(line_para($english_word, 3)),
    # Non-matchers
    'utter nonsense'                        => undef,
    'nonsense word'                         => undef,
    'what is a word of nonsense'            => undef,
    'three french hens and a nonsense word' => undef,
    # 'Large' tests
    '30 Swedish nonsense words'                => build_test(werds($swedish_word, 30)),
    '30 words of french gibberish'             => build_test(werds($french_word, 30)),
    '30 words of gibberish'                    => build_test(werds($english_word, 30)),
    '30 words of utter Shakespearean nonsense' => build_test(werds($shake_word, 30)),
);

done_testing;
