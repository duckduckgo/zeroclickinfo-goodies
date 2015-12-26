package DDG::Goodie::Morse;
# ABSTRACT: Converts to/from Morse code

use strict;
use DDG::Goodie;
use Convert::Morse qw(is_morse as_ascii as_morse);

primary_example_queries 'morse code for ... --- ...';
secondary_example_queries 'morse code for SOS';
description 'convert to and from morse code';
name 'Morse';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Morse.pm';
category 'conversions';
topics 'special_interest';
attribution web     => ['http://und3f.com', 'und3f'],
            twitter => ['und3f', 'und3f'],
            github  => ['und3f', 'und3f'],
            cpan    => ['UNDEF', 'und3f'];

triggers start => "morse code for", "morse for";
triggers end => "to morse code", "to morse";

zci answer_type => 'morse';
zci is_cached   => 1;

handle remainder => sub {
    my $input = shift;

    return unless $input;
    return if($input eq 'cheat sheet');
    return if($input eq 'cheatsheet');
    my $convertor = is_morse($input) ? \&as_ascii : \&as_morse;
    my $result = $convertor->($input);

    return $result,
      structured_answer => {
        input     => [$input],
        operation => 'Morse code conversion',
        result    => html_enc($result),
      };
};

1;
