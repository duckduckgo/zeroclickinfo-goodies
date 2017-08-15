package DDG::Goodie::NaturalToLogic;
# ABSTRACT: Takes a logical expression written in natural language and turns it into formal mathematical notation using Unicode characters.

use DDG::Goodie;

use strict;
use utf8;

zci answer_type => 'natural_to_logic';
zci is_cached   => 1;

triggers startend => 'to logic', 'in logic', 'as logic', 'to logical notation', 'in logical notation', 'as logical notation';

my %symbols = (
    'for all'           => '∀',
    'for each'          => '∀',
    'for every'         => '∀',
    'for any'           => '∀',
    
    'exists'            => '∃',
    
    'not'               => '¬',
    
    'in'                => '∈',
    'is in'             => '∈',
    'lies in'           => '∈',
    'is element of'     => '∈',
    'is an element of'  => '∈',
    'is member of'      => '∈',
    'is a member of'    => '∈',
    'belongs to'        => '∈',
        
    'not in'            => '∉',
    'is not in'         => '∉',
    
    'implies'           => '⇒',
    
    'iff'               => '⇔',
    'equals'            => '⇔',
    'is equal to'       => '⇔',
    
    'and'               => '∧',
    'or'                => '∨'
);

handle remainder => sub {

    return unless $_;

    my $answer = $_; 
    $answer =~ s/\b(@{[join '|', keys %symbols]})\b/$symbols{$1}/g;

    return "\"$_\" converted to formal logical notation: $answer",
        structured_answer => {
            id        => 'natural_to_logic',
            name      => 'Answer',
            
            data      => {
                title       => $answer,
                subtitle    => "Convert to formal logical notation: $_"
            },
            
            meta      => {
                sourceName  => "Wikipedia",
                sourceUrl   => "https://en.wikipedia.org/wiki/List_of_logic_symbols"
            },
            
            templates => {
                group      => 'text'
            }
        };
};

1;