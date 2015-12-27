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

ddg_goodie_test(
    [qw( DDG::Goodie::GibberishGenerator )],
    # Non-matchers
    'utter nonsense'                        => undef,
    'nonsense word'                         => undef,
    'what is a word of nonsense'            => undef,
    'three french hens and a nonsense word' => undef,
);

done_testing;
