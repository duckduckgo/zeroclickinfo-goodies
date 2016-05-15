package DDG::Goodie::Atbash;
# ABSTRACT: A simple substitution cipher using a reversed alphabet

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';

triggers start => 'atbash';

my $matcher = wi(
    groups  => ['command'],
    options => {
        command => qr/atbash/i,
    },
);

zci answer_type => 'atbash';
zci is_cached   => 1;

handle query => sub {
    my $query = shift;
    my $match = $matcher->full_match($query) or return;

    my $in_string = $match->{primary};

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
                subtitle => html_enc("Atbash: $in_string")
            },
            templates => {
                group => 'text',
                moreAt => 0
            }
      };
};

1;
