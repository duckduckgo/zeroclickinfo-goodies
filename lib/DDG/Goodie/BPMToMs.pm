package DDG::Goodie::BPMToMs;
# ABSTRACT: Displays common note values in milliseconds for a given tempo measured in quarter notes per minute.

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
    my $bpm = shift;
    
    return unless $_ =~ /^\d+$/i; # Only integer values accepted
    
    my @note_names = ( "Whole Note", "Half Note", "Quarter Note", "1/8 Note", "1/16 Note", "1/32 Note" );
    my $straight_whole_note = 240000;
    my @divisors = map { 2 ** $_ } 0 .. 5; # Create a list of divisors to calculate the values of half notes, quarter notes etc.
    my @straight_values = map { int( $straight_whole_note / ($bpm * $_) + 0.5) } @divisors;
    
    
    my $plain_text_content = "$bpm bpm in milliseconds
Whole Note: " . $straight_values[0] . "
Half Note: " . $straight_values[1] . "
Quarter Note: " . $straight_values[2] . "
1/8 Note: " . $straight_values[3] . "
1/16 Note: " . $straight_values[4] . "
1/32 Note: " . $straight_values[5];
    
    my $html_content =              "<div class=\"bpmto_ms\">";
    $html_content = $html_content . "<h3 class=\"zci__header\">$bpm bpm in milliseconds</h3>";
    $html_content = $html_content . "<div class=\"zci__content\">";
    $html_content = $html_content . "<div class=\"record\">";
    $html_content = $html_content . "<table class=\"maintable\">";
                                
    for my $i (0 .. $#note_names) {
        $html_content = $html_content . "<tr class=\"record\">";
        $html_content = $html_content . "<td class=\"record__cell__key record_keyspacing\">$note_names[$i]</td>";
        $html_content = $html_content . "<td class=\"record__cell__value numbers\">$straight_values[$i]</td>";
        $html_content = $html_content . "</tr>";
    }
    
    $html_content = $html_content .
    "</table></div></div></div>";
    
    return html => $html_content,
           answer => $plain_text_content;
};

1;