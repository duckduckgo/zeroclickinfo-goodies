package DDG::Goodie::Sha;
# ABSTRACT: Compute a SHA sum for a provided string.

use strict;
use DDG::Goodie;
use Digest::SHA;

zci answer_type => "sha";
zci is_cached   => 1;

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
        data => {
            title => $out,
            subtitle => "SHA-$ver $enc hash",
        },
        templates => {
            group => 'text'
        }
      };
};

1;
