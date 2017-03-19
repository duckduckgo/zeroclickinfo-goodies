package DDG::Goodie::RIPEMD;
# ABSTRACT: Computes the RIPEMD family of cryptographic hash functions. 

use strict;
use DDG::Goodie;
use Crypt::Digest::RIPEMD128;
use Crypt::Digest::RIPEMD160;
use Crypt::Digest::RIPEMD256;
use Crypt::Digest::RIPEMD320;

zci answer_type => "ripemd";
zci is_cached   => 1;

my @triggers = qw(ripemd ripemdsum ripemd128 ripemd128sum ripemd-128 ripemd160 ripemd160sum ripemd-160
               ripemd256 ripemd256sum ripemd-256 ripemd320 ripemd320sum ripemd-320);

triggers start => @triggers;

handle query => sub {
    return unless $_ =~ /^ripemd\-?(?<ver>128|160|256|320|)?(?:sum|)\s*
                        (?<enc>hex|base64|)\s+(?<str>.*)$/ix;

    my $ver = $+{'ver'}    || 160;    # RIPEMD-160 is the most common version in the family
    my $enc = lc $+{'enc'} || 'hex';
    my $str = $+{'str'}    || '';

    $str =~ s/^hash\s+(.*\S+)/$1/;    # Remove 'hash' in queries like 'ripemd hash this'
    $str =~ s/^of\s+(.*\S+)/$1/;      # Remove 'of' in queries like 'ripemd hash of this'
    $str =~ s/^\"(.+)\"$/$1/;         # remove quotes (e.g. ripemd256 "this string")
    return unless $str;

    $enc =~ s/base64/b64/;            # the suffix for the base64 functions is b64 (ex: ripemd160_b64)

    my $func_name = 'Crypt::Digest::RIPEMD' . $ver . '::ripemd' . $ver . '_' . $enc;
    my $func      = \&$func_name;

    my $out = $func->($str);

    # By convention, CPAN Digest modules do not pad their Base64 output, but the
    # Crypt::Digest::RIPEMDXXX doesn't comply with that convention and returns the
    # output with padding. In case they change it in the future and to avoid wrong
    # results the necessary padding will be implemented here.
    if ($enc eq 'base64'){
        while (length($out) % 4) {
            $out .= '=';
        }
    }
    
    my $operation = 'RIPEMD-' . $ver . ' ' . $enc . ' hash';
    return $out, structured_answer => {
        data => {
            title => $out,
            subtitle => "$operation: $str"
        },
        templates => {
            group => 'text'
        }    
    };
};

1;
