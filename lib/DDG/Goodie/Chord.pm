package DDG::Goodie::Chord;
# ABSTRACT: For getting the fingering for chords on popular strings instruments

use DDG::Goodie;

zci answer_type => "chord";
zci is_cached   => 1;

name "Chord";
description "Shows a tab representing the correct frets, for a given chord, on a given strings instrument";
primary_example_queries "C ukulele chord", "F# minor guitar tab";
secondary_example_queries "Ebmaj7 uke chord";
category "reference";
topics "music";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Chord.pm";
attribution github => ["GitHubAccount", "gerhuyy"];


triggers any => "chord", "tab";

# Map note letters to indexes
my %notes = (
    "c"  => 0,    #
    "d"  => 2,
    "e"  => 4,  #
    "f"  => 5,
    "g"  => 7,#
    "a"  => 9,
    "b"  => 11,
);

# Map the distance that the root of a chord is from each note
my %chords = (
    "augmented"  => [0, 4, 8, 11],
    "major"      => [0, 4, 7, 11, 2, 5, 9],
    "dominant"   => [0, 4, 7, 10, 2, 5, 9],
    "minor"      => [0, 3, 7, 10, 2, 5, 9],
    "diminished" => [0, 3, 6, 10],
    "sus2"       => [0, 2, 7],
    "sus4"       => [0, 5, 7],
);

# Store the instruments that the program will respond to, with a 
# list storing the note of each string in order. (Add one to note
# for sharps, and subtract one for flats)
my %instruments = (
    "guitar"  => [$notes{"e"}, $notes{"a"}, $notes{"d"}, $notes{"g"}, $notes{"b"}, $notes{"e"}],
    "ukulele" => [$notes{"g"}, $notes{"c"}, $notes{"e"}, $notes{"a"}],
);
my %instrument_aliases = (
    "uke" => "ukulele"
);
# Find the smallest element in an array
sub minimum{
    my @sorted = sort{ $a <=> $b } (@_);
    return $sorted[0];
};

# Find the largest element in an array
sub maximum{
    my @sorted = sort{ $a <=> $b } (@_);
    return $sorted[-1];
};

# The input parser. Uses regex to find the key to put the chord in, and the 
# chord if they are conjoined. 
# Also greps through the input words, looking for matches within the 
# chords and instrument hashes
sub items{
    my @words = split(" ", lc $_[0]);
    $_[0] = join("sharp", split("#", $_[0]));
    my ($temp, $key, $mod, $chord, $dom, $temp2) = /( |^)([a-g])(sharp|b|)(m|min|minor|M|maj|major|sus[24]|)(5|7|9|11|13|)( |$)/i ;
    if(/( |^)(5|7|9)( |$)/i){
        ($temp, $dom, $temp2) = /( |^)(5|7|9|11|13)( |$)/i;
    }
    if(/( |^)(5|7|9)th( |$)/i){
        ($temp, $dom, $temp2) = /( |^)(5|7|9|11|13)th( |$)/i;
    }
    $mod =  $mod ? ($mod eq "sharp" ? 1 : ($mod eq "b" ? -1 : 0)) : 0;
    my @chordList = grep($chords{$_}, @words);
    if(defined $chordList[0]){
        $chord = $chordList[0];
    }elsif(defined $chord and $chord eq "m" or $chord =~ /(min|minor)/i){
            $chord = "minor";
    }elsif(defined $chord and $chord eq "M" or $chord =~ /(maj|major)/i){
            $chord = "major";
    }elsif(defined $chord and $chord =~ /sus[24]/i){
            $chord = lc $chord;
    }elsif($dom){
        $chord = "dominant";
    }else{
        $chord = "major";
    };
    if(!$dom){
        $dom = 5;
    };
    my @instr = grep($instruments{$_}, @words);
    if(!@instr){
        @instr = $instrument_aliases{(grep($instrument_aliases{$_}, @words))[0]};
    };
    return $instr[0], $chord, $key, $mod, $dom;
};

# Turns a root notes, and a chord (such as from the chord hash), and
# turns it into a chord in the key of that root
sub chord{
    my $root = $_[0];
    my $dis = $_[1];
    return map{($_ + $root) % 12} @$dis;
};

# Takes a starting fret, a chord, such as from the chord function, and an instrument, such
# as from the instrument hash.
# Determines which frets would need to be pressed on that instrument to
# form that chord.
# The starting fret determines the lowest fret that the function will try to 
# put a note on.
sub _frets{
    my ($start, $instrument, $values) = @_;
    my @final = ();
    foreach my $s (@$instrument){
        for(my $f = 0; $f < 12; $f+= $f?1:$start){ #$f starts at zero, then skips to the value of $start
            foreach my $n (@$values){
                if($n == ($s+$f) % 12){
                    push(@final, $f);
                    $f += 12;
                    last;
                };
            };
        };
    };
    return @final;
};

# Takes in all the same vales as _fret, besides a start value. Passes them to 
# _fret with slowly increasing start values. 
# For each array returned by _fret, determines a "distance" between the notes 
# on an instrument. 
# A lower distance then all the previous distances will get that array added 
# to the return array.
sub all_frets{
    my @values;
    my $small_d = 9999999;
    for my $d (1 .. 8){
        my @value = _frets (($d), @_);
        my $distance = 0;
        my $l = 0;
        my $n = -1;
        for my $i (0 .. $#value){
            if($n >= 0 and $value[$i]){
                $distance += $i-$n + abs($value[$i]-$l)
            };
            if($value[$i]){
                $l = $value[$i];
                $n = $i;
            };
        };
        if($distance < $small_d){
            $small_d = $distance;
            push(@values, @value);
        };
    };
    return @values;
};

# Takes a list of frets, such as from the "fret" function. 
# Draws using divs, with classes coming from share/goodie/chord/chord.css
sub get_html_draw{
    my @fret = @_;
    my $length = maximum(@fret, (4));
    my $height = ($length * 25)+5 . "px";
    my $string_height = (($length * 25)) . "px";
    my $width = (@fret * 16) . "px";
    my $final = "<div class='chord' style='width: $width ;height: $height ;'>\n";
    $final .= "  <div class='topfret' style='width: $width'></div>\n";
    $final .= "  <div class='string' style='height: $string_height'></div>\n" x @fret;
    $final .= "  <div class='fret' style='width: $width'></div>\n" x $length;
    for(my $i = 0; $i < @fret; $i++){
        if($fret[$i] == 0){
            my $top = ($length * -25)-7 . "px";
            $final .= "  <div class='zeropoint' style='top: $top'></div>\n";
        }else{
            my $top = (($fret[$i] - ($length))*25)-19.5 . "px";
            $final .= "  <div class='point' style='top: $top'></div>\n";
        };
    };
    return $final . "</div>\n";
};

# Handle statement
handle remainder => sub {
    my ($instr_name, $chord_name, $key_name, $mod, $dom) = items($_);
    if($instr_name and $chord_name and $key_name){
        my @keys = @{$chords{$chord_name}};
        splice(@keys, ($dom+1)/2);
        my @values = chord($notes{lc $key_name}+$mod, \@keys);
        my @frets = all_frets($instruments{$instr_name}, \@values);
        my $strings = 0+@{$instruments{$instr_name}};
        splice(@frets, int(@frets/$strings)*$strings);
        my $html = "";
        my @texts;
        for(my $i = 0; $i < @frets; $i += $strings){
            my @fret = @frets[$i .. $strings + $i - 1];
            $html .= get_html_draw(@fret);
            push(@texts, join("-", @fret));
        };
        my $text = join(", ", @texts);
        my $input = join(" ", (uc $key_name) . (($mod == -1)? "b" :(($mod == 1)? "#" : "" )), 
                    $chord_name . (@keys == 3 ? "" : (" " . (@keys*2 - 1) . "th")));
        my $type = ucfirst($instr_name) . " Chord";
        return $text, structured_answer => {
            input     => [html_enc($input)],
            operation => html_enc($type),
            result    => $html,
        };
    };
    return $_;
};


1;
