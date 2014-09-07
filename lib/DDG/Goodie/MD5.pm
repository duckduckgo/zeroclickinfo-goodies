package DDG::Goodie::MD5;
# ABSTRACT: Calculate the MD5 digest of a string.

use DDG::Goodie;
use Digest::MD5 qw(md5_base64 md5_hex);
use Encode qw(encode);

zci answer_type => 'md5';
zci is_cached => 1;

primary_example_queries 'md5 digest this!';
secondary_example_queries 'duckduckgo md5',
                          'md5sum the sum of a string';

name 'MD5';
description 'Calculate the MD5 digest of a string.';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MD5.pm';
category 'transformations';

triggers startend => 'md5', 'md5sum';

my $css = share('style.css')->slurp;

sub html_output {
    my ($str, $md5) = @_;

    # prevent XSS
    $str = html_enc($str);

    return "<style type='text/css'>$css</style>"
          ."<div class='zci--md5'>"
          ."<span class='text--secondary'>MD5 of \"$str\"</span><br/>"
          ."<span class='text--primary'>$md5</span>"
          ."</div>";
}

handle remainder => sub {
    s/^hash\s+(.*\S+)/$1/; # Remove 'hash' in queries like 'md5 hash this'
    s/^of\s+(.*\S+)/$1/; # Remove 'of' in queries like 'md5 hash of this'
    s/^"(.*)"$/$1/; # Remove quotes
    if (/^\s*(.*\S+)/) {
        # The string is encoded to get the utf8 representation instead of
        # perls internal representation of strings, before it's passed to
        # the md5 subroutine.
        my $str = $1;
        my $md5 = md5_hex(encode "utf8", $str);
        return $md5, html => html_output($str, $md5);
    } else {
        # Exit unless a string is found
	return;
    }
};

1;
