package DDG::Goodie::BPMToMs;
# ABSTRACT: Converts Beats Per Minute to note values in milliseconds.
# Useful when needing to calculate delay times, attack / release times of compressors, reverb lengths etc.

use DDG::Goodie;

zci answer_type => "bpmto_ms";
zci is_cached   => 1;

name "BPM (beats per minute) to ms (milliseconds) converter";
description "Takes a tempo as BPM (beats per minute), eg. 120, and returns the corresponding note values as milliseconds.";
primary_example_queries "120 bpm to ms";
category "conversions";
topics "music";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/BPMToMs.pm";
attribution github => ["https://github.com/stefolof", "stefolof"],
            twitter => "stefolof";

triggers end => "bpm to ms", "bpm to milliseconds", "bpm to note values", "bpm to note lengths", "bpm", "bpm timings", "beats per minute to milliseconds", 
                "beats per minute to ms", "beats per minute to note values", "beats per minute to note lengths", "beats per minute", "beats per minute timings";

handle remainder => sub {
    return unless $_; # Guard against "no answer"
    return unless $_ =~ /^\d+$/i; # Only integer values accepted
    
    my $bpm = $_;
    
    my @divisors = map { 2 ** $_ } 0 .. 6;
    
    my @straight_values = map { int( 240000 / ($bpm * $_) + 0.5) } @divisors;
    my @triplet_values = map { int( 160000 / ($bpm * $_) + 0.5) } @divisors;
    my @dotted_values = map { int( 360000 / ($bpm * $_) + 0.5) } @divisors;
    
    return html => "<div class=\"record\">
                    <div>
                       $bpm BPM as quarter notes per minute corresponds to the following note lengths in milliseconds:
                    </div>
                    <table style=\"border-spacing: 10px; border-collapse: separate;\" class=\"record__body\">
                        <tr class=\"record__row record__highlight\">
                            <td>Whole Note:</td><td>" . $straight_values[0] . " ms</td>
                            <td>Triplet:</td><td>" . $triplet_values[0] . " ms</td>
                            <td>Dotted:</td><td>" . $dotted_values[0] . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>Half Note:</td><td>" . $straight_values[1] . " ms</td>
                            <td>Triplet:</td><td>" . $triplet_values[1] . " ms</td>
                            <td>Dotted:</td><td>" . $dotted_values[1] . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>Quarter Note:</td><td>" . $straight_values[2] . " ms</td>
                            <td>Triplet:</td><td>" . $triplet_values[2] . " ms</td>
                            <td>Dotted:</td><td>" . $dotted_values[2] . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>1/8 Note:</td><td>" . $straight_values[3] . " ms</td>
                            <td>Triplet:</td><td>" . $triplet_values[3] . " ms</td>
                            <td>Dotted:</td><td>" . $dotted_values[3] . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>1/16 Note:</td><td>" . $straight_values[4] . " ms</td>
                            <td>Triplet:</td><td>" . $triplet_values[4] . " ms</td>
                            <td>Dotted:</td><td>" . $dotted_values[4] . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>1/32 Note:</td><td>" . $straight_values[5] . " ms</td>
                            <td>Triplet:</td><td>" . $triplet_values[5] . " ms</td>
                            <td>Dotted:</td><td>" . $dotted_values[5] . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>1/64 Note:</td><td>" . $straight_values[6] . " ms</td>
                            <td>Triplet:</td><td>" . $triplet_values[6] . " ms</td>
                            <td>Dotted:</td><td>" . $dotted_values[6] . " ms</td>
                        </tr>
                   </table>
                   </div>",
                   answer => "$bpm BPM as quarter notes per minute corresponds to the following note lengths in milliseconds:
Whole Note: " . $straight_values[0] . " ms, Triplet: " . $triplet_values[0] . " ms, Dotted: " . $dotted_values[0] . " ms
Half Note: " . $straight_values[1] . " ms, Triplet: " . $triplet_values[1] . " ms, Dotted: " . $dotted_values[1] . " ms
Quarter Note: " . $straight_values[2] . " ms, Triplet: " . $triplet_values[2] . " ms, Dotted: " . $dotted_values[2] . " ms
1/8 Note: " . $straight_values[3] . " ms, Triplet: " . $triplet_values[3] . " ms, Dotted: " . $dotted_values[3] . " ms
1/16 Note: " . $straight_values[4] . " ms, Triplet: " . $triplet_values[4] . " ms, Dotted: " . $dotted_values[4] . " ms
1/32 Note: " . $straight_values[5] . " ms, Triplet: " . $triplet_values[5] . " ms, Dotted: " . $dotted_values[5] . " ms
1/64 Note: " . $straight_values[6] . " ms, Triplet: " . $triplet_values[6] . " ms, Dotted: " . $dotted_values[6] . " ms";
};

1;
