package DDG::Goodie::PigLatin;
# ABSTRACT: convert a given string to pig latin

use strict;
use DDG::Goodie;
use Lingua::PigLatin::Bidirectional;

triggers any => 'pig latin', 'piglatin';

zci answer_type => "translation";
zci is_cached   => 1;

handle query_raw => sub {
    my $query = shift;
    $query =~ s/\s*(?<action>to|from|in)\s*pig ?latin\s*$//i;
    $query =~ s/^\s*(?<action>to|from|in)?+\s*pig ?latin\s*//i unless $+{'action'};
    return unless $query;
    my $action = lc ($+{'action'} // 'to');
    $action = 'to' if $action eq 'in';
    my $result = $action eq 'to' ? to_piglatin($query) : from_piglatin($query);

    return $result, structured_answer => {
        id   => 'pig_latin',
        name => 'Answer',
        data => {
            title    => "$result",
            subtitle => "Translate $action Pig Latin: $query",
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        },
      };
};

1;
