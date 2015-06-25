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
my $html_table = qr#<table class="publicdns">.*</table>$#m;
my $heading    = 'Public DNS Servers';

ddg_goodie_test([qw( DDG::Goodie::PublicDNS)],
    map { ("$_" => test_zci($text_table, html => $html_table, heading => $heading,)) } ('public dns', 'dns servers',));

done_testing;
