package DDG::Goodie::Sha;
# ABSTRACT: Compute a SHA sum for a provided string.

use strict;
use DDG::Goodie;
use Digest::SHA;
with 'DDG::GoodieRole::WhatIs';

zci answer_type => "sha";
zci is_cached   => 1;

my $sha_re = qr/sha\-?(?<ver>1|224|256|384|512|)?(?:sum|)\s*(?<enc>hex|base64|)/i;

triggers query => qr/^$sha_re/i;

my $matcher = wi(
    groups => ['command'],
    options => {
        command => qr/$sha_re(\s+hash(\s+of)?)?/i,
        primary => qr/"(?<text>.+?)"|(?<text>.+)/i,
    },
);

handle query => sub {
    my $query = shift;
    my $match = $matcher->full_match($query) or return;
    my $enc = lc ($match->{enc} || 'hex');
    my $str = $match->{text};
    my $ver = $match->{ver} || 1;

    my $func_name = 'Digest::SHA::sha' . $ver . '_' . $enc;
    my $func      = \&$func_name;

    my $out     = $func->($str);
    my $pre_len = length($out) % 4;
    my $pad     = ($enc eq 'base64' && $pre_len) ? 4 - $pre_len : 0;
    $out .= '=' x $pad if ($pad);

    return $out,
      structured_answer => {
        input     => [html_enc($str)],
        operation => 'SHA-' . $ver . ' ' . $enc . ' hash',
        result    => $out
      };
};

1;
