package DDG::Goodie::MusicScale;
# ABSTRACT: Return the diatonic scale of the key and mode given in the query

use DDG::Goodie;
use strict;

zci answer_type => "music_scale";
zci is_cached   => 1;

name "MusicScale";
description "Look up musical scales";
primary_example_queries "c major scale", "f# minor scale";
category "reference";
topics "music";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MusicScale.pm";
attribution github => ["sublinear", "sublinear"];

# Triggers
triggers end => "major scale", "dorian scale", "phrygian scale", "lydian scale", "mixolydian scale", "minor scale", "locrian scale";

# Handle statement
handle sub {
    return unless $_;

    # must be a note letter, optional sharp or flat, and the mode name followed by the word "scale"
    # e.g. "Gb Dorian Scale"

    return unless ($_ =~ /^([A-Ga-g])([b#])?\s+([mM]ajor|[dD]orian|[pP]hrygian|[lL]ydian|[mM]ixolydian|[mM]inor|[lL]ocrian)\s+([sS]cale)$/ );

    my( $letter, $accidental, $mode, $noteIndex, $modeIndex, @scale, @majorScale, @notes, @modes );

    # regex captures
    if (defined $1) { $letter     = uc($1);      } else { $letter     = ""; }
    if (defined $2) { $accidental = $2;          } else { $accidental = ""; }
    if (defined $3) { $mode       = ucfirst($3); } else { $mode       = ""; }
    
    # lookup arrays
    @majorScale = (0, 2, 4, 5, 7, 9, 11);
    @notes = ("C", "Db/C#", "D", "Eb/D#", "E", "F", "Gb/F#", "G", "Ab/G#", "A", "Bb/A#", "B");
    @modes = ("Major", "Dorian", "Phrygian", "Lydian", "Mixolydian", "Minor", "Locrian");

    # get note index
    if    ( $letter eq "C" ) { $noteIndex = 0;  }
    elsif ( $letter eq "D" ) { $noteIndex = 2;  }
    elsif ( $letter eq "E" ) { $noteIndex = 4;  }
    elsif ( $letter eq "F" ) { $noteIndex = 5;  }
    elsif ( $letter eq "G" ) { $noteIndex = 7;  }
    elsif ( $letter eq "A" ) { $noteIndex = 9;  }
    else                     { $noteIndex = 11; }

    # apply accidental to note index
    if    ( $accidental eq "b" ) { $noteIndex -= 1; }
    elsif ( $accidental eq "#" ) { $noteIndex += 1; }
    $noteIndex %= 12;

    # get mode index
    for (my $i=0; $i < $#modes; $i++) {
        if ($mode eq $modes[$i]) {
            $modeIndex = $i;
            last;
        }
    }

    # generate the scale
    for (my $i=0; $i < 7; $i++) {
        push @scale, $notes[ ($noteIndex + (($majorScale[($i + $modeIndex) % 7] - $majorScale[$modeIndex]) % 12)) % 12 ];
    }

    # result
    return join(", ", @scale),
        structured_answer => {
            input => [html_enc($letter.$accidental." ".$mode." Scale")],
            operation => "Musical Scale",
            result => html_enc(join(", ", @scale)),
        };
};

1;
