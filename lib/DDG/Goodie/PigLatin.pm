package DDG::Goodie::PigLatin;
# ABSTRACT: convert a given string to pig latin

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';
use Lingua::PigLatin::Bidirectional;

triggers any => 'pig latin', 'piglatin';

zci answer_type => "translation";
zci is_cached   => 1;

my $matcher = wi_custom(
    groups => ['translation', 'conversion', 'verb', 'language'],
    options => {
        to => qr/pig ?latin/i,
        from => qr/pig ?latin/i,
        written => 1,
        spoken => 1,
    },
);

handle query => sub {
    my $query = shift;
    $query =~ s/\.$//g;
    my $match = $matcher->full_match($query) or return;
    my $to_translate = $match->{primary};
    my $direction    = $match->{direction};
    my $result = $direction eq 'to'
        ? to_piglatin($to_translate)
        : from_piglatin($to_translate);
    return if $result eq $to_translate;

    return $result, structured_answer => {
        data => {
            title    => html_enc("$result"),
            subtitle => html_enc("Translate $direction Pig Latin: $to_translate"),
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        },
      };
};

1;
