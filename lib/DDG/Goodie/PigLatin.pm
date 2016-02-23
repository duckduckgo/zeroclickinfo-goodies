package DDG::Goodie::PigLatin;
# ABSTRACT: convert a given string to pig latin

use strict;
use DDG::Goodie;
use Lingua::PigLatin::Bidirectional;

triggers any => 'pig latin', 'piglatin';

zci answer_type => "translation";
zci is_cached   => 1;

my $piglatin = qr/pig ?latin/i;
my $actions = qr/(?<action>to|from|in)/i;
my $additional_forms = qr/(?:what is|how (?:(?:do|would) (?:you|I)| to) say)/i;

sub get_action {
    my $query = shift;
    $query =~ s/(^\s+|\s+$)//g;
    $query =~ s/[!.]$//;
    $query =~ s/^$additional_forms\s*+(.+?)\s*+(?<action>in)\s*$piglatin\s*[?]?$/$1/i;
    $+{'action'} // ($query =~ s/^translate\s*+(.+?)\s*+(?<action>from|to)\s*$piglatin$/$1/i);
    $+{'action'} // ($query =~ s/\s*$actions\s*$piglatin$//i);
    $+{'action'} // ($query =~ s/^$actions?+\s*$piglatin\s*//i or return);
    return if $query eq '';
    my $action = lc ($+{'action'} // return);
    $action = 'to' if $action eq 'in';
    return ($query, $action);
}

handle query => sub {
    my $query = shift;
    my ($to_translate, $action) = get_action $query or return;
    return if $to_translate eq '';
    my $result = $action eq 'to'
        ? to_piglatin($to_translate)
        : from_piglatin($to_translate);
    return if $result eq $to_translate;

    return $result, structured_answer => {
        id   => 'pig_latin',
        name => 'Answer',
        data => {
            title    => html_enc("$result"),
            subtitle => html_enc("Translate $action Pig Latin: $to_translate"),
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        },
      };
};

1;
