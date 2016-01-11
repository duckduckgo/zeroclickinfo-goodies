package DDG::Goodie::MD4;
# ABSTRACT: Computes the MD4 cryptographic hash function

use strict;
use DDG::Goodie;
use Digest::MD4;

zci answer_type => "md4";
zci is_cached   => 1;

triggers start => "md4", "md4sum";

handle remainder => sub {
    return unless $_ =~ /^(?<enc>hex|base64|)\s*(?<str>.*)$/i;

    my $enc = lc $+{'enc'} || 'hex';
    my $str = $+{'str'}    || '';
    $str =~ s/^hash\s+(.*\S+)/$1/;    # Remove 'hash' in queries like 'md4 hash this'
    $str =~ s/^of\s+(.*\S+)/$1/;      # Remove 'of' in queries like 'md4 hash of this'
    $str =~ s/^\"(.+)\"$/$1/;         # remove quotes (e.g. md4 "this string")
    return unless $str;

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
