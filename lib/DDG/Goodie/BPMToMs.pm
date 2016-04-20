package DDG::Goodie::BPMToMs;
# ABSTRACT: Displays common note values in milliseconds for a given tempo measured in quarter notes per minute.

use strict;
use DDG::Goodie;

zci answer_type => "bpmto_ms";
zci is_cached   => 1;

triggers end => "bpm to ms", "bpm to milliseconds", "bpm to note values", "bpm to note lengths", "bpm", "bpm timings", "beats per minute to milliseconds",
                "beats per minute to ms", "beats per minute to note values", "beats per minute to note lengths", "beats per minute", "beats per minute timings";

my @note_names  = ( "Whole Note", "Half Note", "Quarter Note", "1/8 Note", "1/16 Note", "1/32 Note" );
my @note_links  = ( "whole note", "half note", "quarter note", "eighth note", "sixteenth note", "thirty-second note" );
my @image_names = ( "whole.svg", "half.svg", "quarter.svg", "8th.svg", "16th.svg", "32nd.svg" );
my @images = map { scalar share($_)->slurp } @image_names;

# The basic note lengths for each category
my $straight_whole_note = 240000;
my $triplet_whole_note = 160000;
my $dotted_whole_note = 360000;
my @divisors = map { 2 ** $_ } 0 .. 5; # Create a list of divisors to calculate the values of half notes, quarter notes etc.

handle remainder => sub {
    my $bpm = shift;

    return unless $bpm =~ /^\d+$/i; # Only integer values accepted

    my @straight_values = map { int( $straight_whole_note / ($bpm * $_) + 0.5) } @divisors;
    my @triplet_values = map { int( $triplet_whole_note / ($bpm * $_) + 0.5) } @divisors;
    my @dotted_values = map { int( $dotted_whole_note / ($bpm * $_) + 0.5) } @divisors;

    my $plaintext = "$bpm bpm in milliseconds:";
    $plaintext .= "\nWhole Note: $straight_values[0], Triplet: $triplet_values[0], Dotted: $dotted_values[0]";
    $plaintext .= "\nHalf Note: $straight_values[1], Triplet: $triplet_values[1], Dotted: $dotted_values[1]";
    $plaintext .= "\nQuarter Note: $straight_values[2], Triplet: $triplet_values[2], Dotted: $dotted_values[2]";
    $plaintext .= "\n1/8 Note: $straight_values[3], Triplet: $triplet_values[3], Dotted: $dotted_values[3]";
    $plaintext .= "\n1/16 Note: $straight_values[4], Triplet: $triplet_values[4], Dotted: $dotted_values[4]";
    $plaintext .= "\n1/32 Note: $straight_values[5], Triplet: $triplet_values[5], Dotted: $dotted_values[5]";

    my @items;

    for my $i (0..$#note_names) {
        my %result = (
            note_type => $note_names[$i],
            milliseconds => $straight_values[$i],
            triplet => $triplet_values[$i],
            dotted => $dotted_values[$i],
            image => $images[$i],
            url => "https://duckduckgo.com/?q=" . $note_links[$i] . "&ia=about",
        );
        push @items, \%result;
    };

    return $plaintext,
        structured_answer => {
            data => \@items,
            meta => {
                sourceUrl => "https://wikipedia.org/wiki/Tempo#Beats_per_minute",
                sourceName => "Wikipedia"
            },
            templates => {
                group => 'base',
                detail => 0,
                options => {
                    content => 'DDH.bpmto_ms.content',
                }
            }
        };
};

1;
