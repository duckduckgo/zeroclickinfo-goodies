package DDG::Goodie::Base64;
# ABSTRACT: Base64 <-> Unicode

use strict;
use DDG::Goodie;
use Text::Trim;

use MIME::Base64;
use Encode;

triggers start => "base64";

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
            github  => ['http://github.com/rpicard', 'Robert Picard'],
            twitter => ['http://twitter.com/__rlp',  'Robert Picard'],
            web     => ['http://robb.weblaws.org/about', 'Robb Shecter'],
            github  => ['http://github.com/dogweather',  'Robb Shecter'],
            twitter => ['http://twitter.com/dogweather', 'Robb Shecter'];




handle remainder => sub {
    my ($command, $input) = query_components($_);
    return unless $input;

    my $output = perform_conversion($command, $input);
    
    my $operation = 'Base64 ' . $command;
    my $text_output = $operation . 'd: ' . $output;
    return $text_output,
      structured_answer => {
        input     => [html_enc($input)],
        operation => $operation,
        result    => html_enc($output),
      };
};


# Parse the query into its two components:
# an optional command (encode or decode), 
# and an input string.
sub query_components {
    my $query = shift;
    $query =~ /^(?<command>encode|decode|)\s*(?<input>.*)$/i;
    my $command = lc($+{'command'}) || 'encode';
    return ($command, $+{'input'});
}


sub perform_conversion {
    my ($command, $input) = @_;
    return trim(decode("UTF-8", decode_base64($input))) if($command eq 'decode');
    return trim(encode_base64(encode("UTF-8", $input)));
}


1;
