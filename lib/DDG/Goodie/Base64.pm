package DDG::Goodie::Base64;
# ABSTRACT: Base64 <-> Unicode

use DDG::Goodie;

use MIME::Base64;
use Encode;

triggers startend => "base64";

zci answer_type => "base64_conversion";
zci is_cached   => 1;

primary_example_queries 'base64 encode foo';
secondary_example_queries 'base64 decode dGhpcyB0ZXh0';
description 'encode to and decode from base64';
name 'Base64';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Base64.pm';
category 'conversions';
topics 'programming';
attribution web     => ['robert.io',                 'Robert Picard'],
            github  => ['http://github.com/rpicard', 'rpicard'],
            twitter => ['http://twitter.com/__rlp',  '__rlp'];

handle remainder => sub {
    return unless $_ =~ /^(?<com>encode|decode|)\s*(?<str>.*)$/i;

    my ($command, $in_str) = (lc($+{'com'}) || 'encode', $+{'str'});

    return unless $in_str;

    my $out_str = ($command eq 'decode') ? decode("UTF-8", decode_base64($in_str)) : encode_base64(encode("UTF-8", $in_str));
    chomp $out_str;

    return unless $out_str;
    my $what = 'base64 ' . $command;

    return ucfirst($what) . 'd: ' . $out_str,
      structured_answer => {
        input     => [$in_str],
        operation => $what,
        result    => $out_str,
      };
};

1;
