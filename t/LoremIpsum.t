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
                moreAt => 1
            }
        }
    };
};


sub build_test { test_zci(build_result(qr/^$_[0]$/)) }


done_testing;
