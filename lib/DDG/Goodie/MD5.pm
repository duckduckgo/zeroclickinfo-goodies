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

my $css = share('style.css')->slurp;

sub html_output {
    my $md5 = shift;
    return "<style type='text/css'>$css</style>"
          ."<div class='zci--md5'>"
          ."<span class='text--secondary'>Md5:</span>"
          ."<span class='text--primary'> $md5</span>"
          ."</div>";
}

handle remainder => sub {
    # Exit unless a string is found after the mode (if any)
    if (/^(hex|base64|)\s*(.*)$/i) {
        my $command = $1 || '';
        my $str     = $2 || '';
        return unless $str;

        if ($command && $command eq 'base64') {
            # Calculate the md5 of the string and return it in base64 if that
            # is the selected mode.
            # The string is encoded to get the utf8 representation instead of
            # perls internal representation of strings, before it's passed to
            # the md5 subroutine.
            $str = md5_base64 (encode "utf8", $str);
        }
        else {
            # Defaults to hex encoding when no other mode was selected.
            $str = md5_hex (encode "utf8", $str);
        }
        return $str, html => html_output $str;
    }
    return;
};

1;
