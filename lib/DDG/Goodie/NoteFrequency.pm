package DDG::Goodie::NoteFrequency;
# ABSTRACT: Return the frequency (Hz) of the note given in the query

use DDG::Goodie;
use strict;

zci answer_type => "note_frequency";
zci is_cached   => 1;

# Triggers
triggers any => "notefreq", "notefrequency", "note frequency", "note frequency of", "frequency of note";

# Handle statement
handle remainder => sub {

    return unless $_;

    # must be a note letter, optional sharp or flat,
    # octave number, optional tuning frequency for A4,
    # and optional case-insensitive "hz" with or without preceding whitespace
    # e.g. "g#3 432 hz" or "ab5 435Hz"

    return unless ($_ =~ /^([A-Ga-g])([b#])?([0-8])(\s+[0-9]{1,4})?(\s?[hH][zZ])?$/ );

    my( $letter, $accidental, $octave, $tuning, $pitchClass, $midi, $frequency );

    # regex captures
    if (defined $1) { $letter     = uc($1); } else { $letter     = ""; }
    if (defined $2) { $accidental = $2;     } else { $accidental = ""; }
    if (defined $3) { $octave     = $3 + 0; } else { $octave     = 0;  }
    if (defined $4) { $tuning     = $4 + 0; } else { $tuning     = 0;  }

    # assume 440Hz tuning unless otherwise specified
    if ( $tuning == 0 ) { $tuning = 440; }

    # convert note letter to pitch class number
    if    ( $letter eq "C" ) { $pitchClass = 0;  }
    elsif ( $letter eq "D" ) { $pitchClass = 2;  }
    elsif ( $letter eq "E" ) { $pitchClass = 4;  }
    elsif ( $letter eq "F" ) { $pitchClass = 5;  }
    elsif ( $letter eq "G" ) { $pitchClass = 7;  }
    elsif ( $letter eq "A" ) { $pitchClass = 9;  }
    else                     { $pitchClass = 11; }

    # apply accidental to pitch class number
    if    ( $accidental eq "b" ) { $pitchClass -= 1; }
    elsif ( $accidental eq "#" ) { $pitchClass += 1; }

    # calculate MIDI number
    $midi = ( 12 * ($octave + 1) ) + $pitchClass;

    # fix pitch class number
    $pitchClass %= 12;

    # validate note is between C0 and B8
    return unless ( $midi >= 12 && $midi <= 119 );

    # calculate frequency
    $frequency = $tuning * ( 2 ** (($midi-69)/12) );

    # round to two decimal places (is never negative anyway and avoids libs)
    $frequency = int(100 * ($frequency + 0.005)) / 100;

    # result
    return $frequency,
        structured_answer => {
            data => {
                title    => $frequency." Hz",
                subtitle => "Note Frequency: $letter$accidental$octave in A$tuning tuning",
            },
            templates => {
                group => 'text',
            },
        };
};

1;
