package DDG::Goodie::Chords;
# ABSTRACT: Chord (music) calculations.

## TODO: Clean it up! It's so ugly!

use DDG::Goodie;
use GD::Chord::Piano;
use GD::Tab::Guitar;
use MIME::Base64;

triggers startend => "piano", "chord", "scale";

my %keys = (
    ab => 0.5,
    a  => 1,
    bb => 1.5,
    b  => 2,
    #cb => 2.5,
    c  => 2.5,
    db => 3,
    d  => 3.5,
    eb => 4,
    e  => 4.5,
    f  => 5,
    gb => 5.5,
    g  => 6,
);

my %rkeys = reverse %keys;

my %scales = (
    major => [1, 1, 0.5, 1, 1, 1, 0.5],
    minor => [1, 0.5, 1, 1, 0.5, 1, 1],
);

my %chords = ( # 'x-' syntax here means a minor x
    major => ["major", 0, 2, 4],
    minor => ["minor", 0, 2, 4],
    sus4  => ["major", 0, 3, 4],
    sus2  => ["major", 0, 1, 4],
    m7    => ["minor", 0, 2, 4, 6],
    7     => ["major", 0, 2, 4, '6-'],
    m9    => ["minor", 0, 2, 4, '6-', 8],
    9     => ["major", 0, 2, 4, '6-', 8],
    aug   => ["major", 0, 2, '4+'],
    m     => ["minor", 0, 2, 4],
);

my $regex_chords = join('|', keys %chords);

sub wrap {
    $_[0] += 6 if $_[0] < 0.5;
    $_[0] -= 6 while $_[0] > 6;
    $_[0] += 0.5 unless exists $rkeys{$_[0]};
    $_[0] -= 6 if $_[0] > 6; # check again for Ab (G#)
    return $_[0];
}

sub scale {
    my ($start, $chord_pattern, @intervals) = @_;
    my @notes = (ucfirst flat_to_sharp($rkeys{$start}));
    my @nums = ($start);

    my $last = $start;
    for (@intervals) {
        $last = wrap $last+$_;
        push @nums, $last;
        my $chord = $rkeys{$last};
        $chord = ucfirst flat_to_sharp(lc($chord)) . " (\u$chord)" if $chord =~ /^.b$/;
        push @notes, ucfirst $chord;
    }

    my @chord = chord($chords{$chord_pattern}, \@nums);
    return \@notes, \@chord;
}

sub chord {
    my ($intervs, $scale) = @_;
    my @intervals = @{$intervs};
    shift @intervals;
    my @chord;
    for (@intervals) {
        if ($_ !~ /-$/) {
            $_ = $_ - @$scale if $_ >= @$scale; # wrap it around to the length of the scale
            push @chord, ucfirst flat_to_sharp($rkeys{$$scale[$_]});
        }
        else {
            $_ =~ s/-$//;
            my $note = $rkeys{wrap($_-0.5)};
            push @chord, ucfirst(flat_to_sharp($note)) . " (\u$note)";
        }
    }
    return @chord;
}

sub relative_minor {
    # Given a key, find its relative minor
    flat_to_sharp($rkeys{wrap $keys{$_[0]}-1.5});
}
sub relative_major {
    # Opposite of the above
    $rkeys{wrap $keys{$_[0]}+1.5};
}

sub flat_to_sharp {
    # Given a flat note (flats are used in all computations just because), find the equal sharp
    $_[0] =~ /^.b$/ ? $rkeys{wrap $keys{$_[0]}-0.5}.'#' : $_[0];
}

sub sharp_to_flat {
    $_[0] =~ s/#$//;
    $rkeys{wrap $keys{$_[0]}+0.5};
}

my $piano = GD::Chord::Piano->new;
my $guitar = GD::Tab::Guitar->new;

handle query_lc => sub {
    return unless /(\b([a-g])\s*([b#]|flat|sharp)?\s*($regex_chords)?)\b/;
    my ($base, $full, $mod, $chord_pattern) = ($2, $1, $3, $4); # $mod is flat or sharp, $chord_pattern is minor, 7th, 9th, etc.

    local $/ = " ";
    chomp $full;

    $chord_pattern //= "major";
    my $pattern = @{$chords{$chord_pattern}}[0];
    $base .= 'b' if defined $mod and $mod =~ /^(?:b|flat)$/;
    $base = sharp_to_flat $base if defined $mod and $mod =~ /^(?:#|sharp)$/;
    return unless exists $keys{$base};

    my ($scale, $chord) = scale $keys{$base}, $chord_pattern, @{$scales{$pattern}};
    my $relative = $pattern eq 'minor' ? relative_major $base : relative_minor $base;
    my $rel_term = $pattern eq 'minor' ? 'Major' : 'Minor';
    
    my ($piano_gif, $guitar_gif);
    eval { # quietly fail if this doesn't work...
        my $ext_chord_pattern = $chord_pattern;
        $ext_chord_pattern = '' if $ext_chord_pattern eq 'major';
        $ext_chord_pattern = 'm' if $ext_chord_pattern eq 'minor';
        $piano_gif = encode_base64($piano->chord(ucfirst($base.$ext_chord_pattern))->gif); $piano_gif =~ s/\n//g; 
        $guitar_gif = encode_base64($guitar->chord(ucfirst($base.$ext_chord_pattern))->gif); $guitar_gif =~ s/\n//g; 
    }; 

    my $answer = "\u$base \u$pattern scale: ". join(', ',@{$scale}) . " ~ Relative $rel_term: \u$relative $rel_term ~ \u$full Chord: " . join(', ',@{$chord});
    return $answer, html => $answer 
        . (defined $piano_gif ? "<br/><img alt='keyboard' src='data:image/gif;base64,$piano_gif' style='display:inline;margin-right:1em;'/>" : "")
        . (defined $guitar_gif ? "<img alt='guitar' src='data:image/gif;base64,$guitar_gif' style='display:inline;'/>" : "")
        ;
};

zci is_cached => 1;

1;
