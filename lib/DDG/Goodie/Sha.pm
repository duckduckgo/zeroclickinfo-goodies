package DDG::Goodie::Sha;
# ABSTRACT: Compute a SHA sum for a provided string.

use DDG::Goodie;
use Digest::SHA;

zci answer_type => "sha";
zci is_cached   => 1;

primary_example_queries 'SHA this';
secondary_example_queries 'sha-512 that', 'sha512sum dim-dims', 'sha hash of "this and that"';
description 'SHA hash cryptography';
name 'SHA';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Sha.pm';
category 'calculations';
topics 'cryptography';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'duckduckgo', 'DuckDuckGo'],
            twitter => ['duckduckgo', 'DuckDuckGo'];


triggers query => qr/^
    sha\-?(?<ver>1|224|256|384|512|)?(?:sum|)\s*
    (?<enc>hex|base64|)\s+
    (?<str>.*)
    $/ix;

handle query => sub {
    my $ver = $+{'ver'}    || 1;
    my $enc = lc $+{'enc'} || 'hex';
    my $str = $+{'str'}    || '';

    $str =~ s/^hash\s+(.*\S+)/$1/;    # Remove 'hash' in queries like 'sha hash this'
    $str =~ s/^of\s+(.*\S+)/$1/;      # Remove 'of' in queries like 'sha hash of this'
    $str =~ s/^\"(.*)\"$/$1/;         # remove quotes (e.g. sha1 "this string")
    return unless $str;

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
