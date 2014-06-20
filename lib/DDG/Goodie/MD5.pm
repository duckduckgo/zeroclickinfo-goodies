package DDG::Goodie::MD5;
# ABSTRACT: Calculate the MD5 digest of a string.

use DDG::Goodie;
use Digest::MD5 qw(md5_base64 md5_hex);
use Encode qw(encode);

zci answer_type => 'md5';
zci is_cached => 1;

primary_example_queries 'md5 digest this!';
secondary_example_queries 'md5 hex gimme the hex digest',
                          'md5sum base64 gimme the digest encoded in base64';

name 'MD5';
description 'Calculate the MD5 digest of a string.';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MD5.pm';
category 'transformations';

triggers start => 'md5', 'md5sum';

handle remainder => sub {
    if (/^(hex|base64|)\s*(.*)$/i) {
        my $command = $1 || '';
        my $str     = $2 || '';
        return unless $str;

        if ($command && $command eq 'base64') {
            $str = md5_base64 (encode "utf8", $str);
        }
        else {
            $str = md5_hex (encode "utf8", $str);
        }
        return qq(Md5: $str);
    }
    return;
};

1;
