package DDG::Goodie::Atbash;
# ABSTRACT: A simple substitution cipher using a reversed alphabet

use strict;
use DDG::Goodie;

primary_example_queries 'atbash hello';
secondary_example_queries 'atbash svool';
description 'A simple substitution cipher using a reversed alphabet';
name 'Atbash';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Atbash.pm';
category 'transformations';
topics 'cryptography';

attribution web     => ['http://kyokodaniel.com/tech/',      'Daniel Davis'],
            github  => ['https://github.com/tagawa',         'Daniel Davis'],
            twitter => ['https://twitter.com/ourmaninjapan', 'Daniel Davis'];

triggers start => 'atbash';

zci answer_type => 'atbash';
zci is_cached   => 1;

handle remainder => sub {

    my $in_string = $_;

    return unless $in_string;

    my $result;
    foreach my $char (split //, $in_string) {
        if ($char =~ /([a-z])/) {
            # Substitute lowercase characters
            $char = chr(219 - ord $1);
        } elsif ($char =~ /([A-Z])/) {
            # Substitute uppercase characters
            $char = chr(155 - ord $1);
        }
        $result .= $char;
    }

    return "Atbash: $result",
        structured_answer => {
            id => 'atbash',
            name => 'Answer',
            data => {
                title => "$result",
                subtitle => html_enc("Atbash: $in_string")
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
      };
};

1;
