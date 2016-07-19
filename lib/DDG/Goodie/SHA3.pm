package DDG::Goodie::SHA3;
# ABSTRACT: Computes the SHA-3 cryptographic hash function

use strict;
use DDG::Goodie;
use Digest::SHA3;

zci answer_type => "sha3";
zci is_cached   => 1;

my @triggers = qw(sha3 sha3sum sha3-224 sha3-256 sha3-384 sha3-512 
                  shake128 shake-128 shake256 shake-256);
triggers start => @triggers;

handle query => sub {
    return unless $_ =~ /^(?<alg>sha3|shake)\-?(?<ver>128|224|256|384|512|)?(?:sum|)\s*
                        (?<enc>hex|base64|)\s+(?<str>.*)$/ix;

    my $alg = lc $+{'alg'};
    my $ver = $+{'ver'}    || '512';           # SHA3-512 by default
    return if $alg eq 'sha3' && $ver eq '128'; # Special case to avoid the search 'sha3-128' 
                                               # (128 is only valid for SHAKE)
    my $enc = lc $+{'enc'} || 'hex';
    my $str = $+{'str'}    || '';
    $str =~ s/^hash\s+(.*\S+)/$1/; # Remove 'hash' in queries like 'sha3-224 hash this'
    $str =~ s/^of\s+(.*\S+)/$1/;   # Remove 'of' in queries like 'sha3-256 hash of this'
    $str =~ s/^\"(.+)\"$/$1/;      # remove quotes (e.g. sha3-384 "this string")
    return unless $str;

    my $alg_name  = $alg eq "sha3" ? $alg . '_' : $alg; # The functions prefix for sha3 is "sha3_"
    my $func_name = 'Digest::SHA3::' . $alg_name . $ver . '_' . $enc;
    my $func      = \&$func_name;

    my $out = $func->($str);

    # By convention, CPAN Digest modules do not pad their Base64 output. So any
    # necessary padding will be implemented here
    my $modulo  = length($out) % 4;
    my $pad     = ($enc eq 'base64' && $modulo) ? 4 - $modulo : 0;
    $out .= '=' x $pad if ($pad);

    return $out, structured_answer => {
        data => {
            title => html_enc($out),
            subtitle => html_enc(uc($alg) . "-$ver $enc hash").": ".html_enc($str)
        },
        templates => {
            group => 'text'
        }
    };
};

1;
