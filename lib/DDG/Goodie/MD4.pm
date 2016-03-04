package DDG::Goodie::MD4;
# ABSTRACT: Computes the MD4 cryptographic hash function

use strict;
use DDG::Goodie;
use Digest::MD4;
with 'DDG::GoodieRole::WhatIs';

zci answer_type => "md4";
zci is_cached   => 1;

triggers start => "md4", "md4sum";

my $matcher = wi_custom(
    groups  => ['imperative', 'prefix'],
    options => {
        command => qr/(md4(sum)?)(\s+(?<enc>hex|base64))?+(\s+hash(\s+of)?)?/i,
        primary => qr/"(?<primary>.+)"|(?<primary>.+)/,
    },
);

handle query => sub {
    my $query = shift;
    my $match = $matcher->full_match($query) or return;
    my $enc = lc ($match->{enc} || 'hex');
    my $str = $match->{primary};

    my $func_name = 'Digest::MD4::md4_' . $enc;
    my $func      = \&$func_name;

    my $out = $func->($str);

    # By convention, CPAN Digest modules do not pad their Base64 output. So any
    # necessary padding will be implemented here
    if ($enc eq 'base64'){
        while (length($out) % 4) {
            $out .= '=';
        }
    }

    return $out,
        structured_answer => {
            input     => [html_enc($str)],
            operation => html_enc('MD4 ' . $enc . ' hash'),
            result    => html_enc($out)
        };

};

1;
