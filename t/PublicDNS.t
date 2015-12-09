#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "public_dns";
zci is_cached   => 1;

# We don't want to test too specifically on the included data, so just confirm
# we got an answer with something approaching the correct form.
# Hopefully, some one has eyeballed the output to make sure its got the right data.
my $text_table = qr#^\+-+.*-+\+#m;

ddg_goodie_test([qw( DDG::Goodie::PublicDNS)],
    'public dns' => test_zci(
        $text_table,
        structured_answer => {
            id => 'public_dns',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'list',
                options => {
                    list_content => 'DDH.public_dns.content',
                }
            }
        }
    ),
    'dns servers' => test_zci(
        $text_table,
        structured_answer => {
            id => 'public_dns',
            name => 'Answer',
            data => '-ANY-',
            templates => {
                group => 'list',
                options => {
                    list_content => 'DDH.public_dns.content',
                }
            }
        }
    )
);

done_testing;
