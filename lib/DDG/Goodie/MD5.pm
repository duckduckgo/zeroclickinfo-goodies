package DDG::Goodie::MD5;
# ABSTRACT: Calculate the MD5 digest of a string.

use utf8;
use DDG::Goodie;
use Digest::MD5 qw(md5_base64 md5_hex);
use Encode qw(encode);

zci answer_type => 'md5';
zci is_cached => 1;

primary_example_queries 'md5 digest this!';
secondary_example_queries 'duckduckgo md5',
                          'md5sum the sum of a string',
                          'md5 base64 this string';

name 'MD5';
description 'Calculate the MD5 digest of a string.';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MD5.pm';
category 'calculations';
topics 'cryptography';
attribution web => ['http://www.guttula.com', 'Jarmo Kivekäs'],
            github => ['jarmokivekas', 'Jarmo Kivekäs'];


triggers startend => 'md5', 'md5sum';

handle remainder => sub {
    #Remove format specifier from e.g 'md5 base64 this'
    s/^(hex|base64)\s+(.*\S+)/$2/;
    my $format = $1 || 'hex';
    s/^hash\s+(.*\S+)/$1/;    # Remove 'hash' in queries like 'md5 hash this'
    s/^of\s+(.*\S+)/$1/;      # Remove 'of' in queries like 'md5 hash of this'
    s/^"(.*)"$/$1/;           # Remove quotes

    # return if there is nothing left to hash
    return unless (/^\s*(.*\S+)/);

    # The string is encoded to get the utf8 representation instead of
    # perls internal representation of strings, before it's passed to
    # the md5 subroutine.
    my $str = encode("utf8", $1);
    # use approprite output format, default to hex
    # base64 padding is always '==' because hashes have a constant length
    my $md5 = $format eq 'base64' ? md5_base64($str) . '==' : md5_hex($str);

    return $md5,
      structured_answer => {
        input     => [html_enc($str)],
        operation => 'MD5 ' . $format . ' hash',
        result    => $md5
      };
};

1;
