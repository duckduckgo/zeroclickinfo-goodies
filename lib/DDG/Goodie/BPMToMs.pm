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

triggers end => "bpm to ms";

handle remainder => sub {
    return unless $_; # Guard against "no answer"
    return unless $_ =~ /^\d+$/i; # Only integer values accepted
    
    return html => "<div class=\"record\">
                    <table style=\"border-spacing: 10px; border-collapse: separate;\" class=\"record__body\">
                        <tr class=\"record__row record__highlight\">
                            <td>Whole Note:</td><td>" . 240000 / $_ . " ms</td>
                            <td>Triplet:</td><td>" . 160000 / $_ . " ms</td>
                            <td>Dotted:</td><td>" . 360000 / $_ . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>Half Note:</td><td>" . 120000 / $_ . " ms</td>
                            <td>Triplet:</td><td>" . 80000 / $_ . " ms</td>
                            <td>Dotted:</td><td>" . 180000 / $_ . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>Quarter Note:</td><td>" . 60000 / $_ . " ms</td>
                            <td>Triplet:</td><td>" . 40000 / $_ . " ms</td>
                            <td>Dotted:</td><td>" . 90000 / $_ . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>1/8 Note:</td><td>" . 30000 / $_ . " ms</td>
                            <td>Triplet:</td><td>" . 20000 / $_ . " ms</td>
                            <td>Dotted:</td><td>" . 45000 / $_ . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>1/16 Note:</td><td>" . 15000 / $_ . " ms</td>
                            <td>Triplet:</td><td>" . 10000 / $_ . " ms</td>
                            <td>Dotted:</td><td>" . 22500 / $_ . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>1/32 Note:</td><td>" . 7500 / $_ . " ms</td>
                            <td>Triplet:</td><td>" . 5000 / $_ . " ms</td>
                            <td>Dotted:</td><td>" . 11250 / $_ . " ms</td>
                        </tr>
                        <tr class=\"record__row record__highlight\">
                            <td>1/64 Note:</td><td>" . 3750 / $_ . " ms</td>
                            <td>Triplet:</td><td>" . 2500 / $_ . " ms</td>
                            <td>Dotted:</td><td>" . 5625 / $_ . " ms</td>
                        </tr>
                   </table>
                   </div>",
                   answer => "Whole Note: " . 240000 / $_ . " ms, Triplet: " . 160000 / $_ . " ms, Dotted: " . 360000 / $_ . " ms
Half Note: " . 120000 / $_ . " ms, Triplet: " . 80000 / $_ . " ms, Dotted: " . 180000 / $_ . " ms
Quarter Note: " . 60000 / $_ . " ms, Triplet: " . 40000 / $_ . " ms, Dotted: " . 90000 / $_ . " ms
1/8 Note: " . 30000 / $_ . " ms, Triplet: " . 20000 / $_ . " ms, Dotted: " . 45000 / $_ . " ms
1/16 Note: " . 15000 / $_ . " ms, Triplet: " . 10000 / $_ . " ms, Dotted: " . 22500 / $_ . " ms
1/32 Note: " . 7500 / $_ . " ms, Triplet: " . 5000 / $_ . " ms, Dotted: " . 11250 / $_ . " ms
1/64 Note: " . 3750 / $_ . " ms, Triplet: " . 2500 / $_ . " ms, Dotted: " . 5625 / $_ . " ms";
};

1;
