package DDG::Goodie::Atbash;
# ABSTRACT: A simple substitution cipher using a reversed alphabet

use strict;
use DDG::Goodie;

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
            data => {
                title => "$result",
                subtitle => "Atbash: $in_string"
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
      };
};

1;
