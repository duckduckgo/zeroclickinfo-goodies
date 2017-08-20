package DDG::Goodie::ChordDiagrams;
# ABSTRACT: For getting the fingering for chords on popular strings instruments

use DDG::Goodie;
use SVG;
use JSON::MaybeXS;
use List::Util qw(min);
# docs: http://search.cpan.org/~ronan/SVG-2.33/lib/SVG/Manual.pm

zci answer_type => "chord_diagrams";
zci is_cached   => 1;

triggers any => "chord", "tab", "chords", "tabs";

# Store the instruments that the program will respond to, with a
# list storing the note of each string in order. (Add one to note
# for sharps, and subtract one for flats)
my %instruments = (
    guitar => {
        chords => decode_json(share('guitar.json')->slurp),
        strings => 6,
        names => 'guitar'
    },
    ukulele => {
        chords => decode_json(share('ukulele.json')->slurp),
        strings => 4,
        names => 'ukulele|uke'
    }
);

# create svg X for muted strings
sub mk_x {
    my $svg = shift;
    my $x = shift;
    my $y = shift;
    my $size = shift;

    $svg->line(
    x1 => $x - $size/2,
    y1 => $y - $size/2,
    x2 => $x + $size/2,
    y2 => $y + $size/2,
    style => {
        'stroke-width'=>'2'
    });

    $svg->line(
    x1 => $x - $size/2,
    y1 => $y + $size/2,
    x2 => $x + $size/2,
    y2 => $y - $size/2,
    style => {
        'stroke-width' => '2'
    });
};

# Generate chord SVG
sub gen_svg {
    my (%opts) = @_;
    my $svg = SVG->new(width => $opts{"width"}, height => $opts{"height"});
    my $top_pad = 20;
    my $start = 0;
    my @t = grep {$_ != -1} @{$opts{"points"}};

    if ((my $m = min @t) > 2) {
        $start = $m - 1;

        $svg->text(
            style => {
                'font'      => 'Arial',
                'font-size' => '14'
            },
            x               => -15,
            y               => $top_pad + 5
        )->cdata($start);
    }
    if($start == 0) {
        $svg->line(
        x1 => 0,
        y1 => $top_pad,
        x2 => $opts{"width"},
        y2 => $top_pad,
        style => {
            'stroke-width' => '4'
        });
    }

    # draw frets
    my $fret_dist = (($opts{"height"} - $top_pad) / ($opts{"frets"}));
    for (my $i = 0; $i < $opts{"frets"}; $i++) {
        $svg->line(
        x1 => 0,
        y1 => $top_pad + 2 + $i * $fret_dist,
        x2 => $opts{"width"},
        y2 => $top_pad + 2 + $i * $fret_dist,
        style => {
            'stroke-width' => '2'
        });
    }

    # draw strings
    for (my $i = 0; $i < $opts{"strings"}; $i++) {
        $svg->line(
        x1 => 1 + $i * (($opts{"width"} - 2) / ($opts{"strings"} - 1)),
        y1 => $top_pad,
        x2 => 1 + $i * (($opts{"width"} - 2) / ($opts{"strings"} - 1)),
        y2 => $opts{"height"},
        style => {
            'stroke-width' => '2'
        });
    }

    # draw finger positions
    my $i = 0;
    my $p_dist = ($opts{"width"} - 2) / ($opts{"strings"} - 1);
    for my $p (@{$opts{"points"}}) {
        last if ($i >= $opts{"strings"});
        if ($p == -1) {
            mk_x($svg, $i * $p_dist + 1,
                 $top_pad - $fret_dist/2 + 1,
                 10);
        } elsif($p == 0) {
            $svg->circle(
            cx => $i * $p_dist + 1,
            cy => $top_pad + $fret_dist * ($p - $start) - $fret_dist/2 + 2,
            r => 5,
            style => {
                'stroke-width' => 2,
                'fill' => 'none'
            });
        } else {
            $svg->circle(
            cx => $i * $p_dist + 1,
            cy => $top_pad + $fret_dist * ($p - $start) - $fret_dist/2 + 2,
            r => 5,
            style => {
                'stroke-width' => 2
            });
        }
        $i++;
    }
    return $svg;
};


# used in items
my %mod_hash = (sharp => '#', b => 'b');

# The input parser. Uses regex to find the key to put the chord in, and the
# chord if they are conjoined.
# Also greps through the input words, looking for matches within the
# chords and instrument hashes
sub items {
    my @words = split(" ", lc $_[0]);
    $_[0] = join("sharp", split("#", $_[0]));
    my ($temp, $key, $mod, $chord, $dom, $temp2) = /( |^)(?:\s)*([a-g])(?:\s)*(sharp|b|)(?:\s)*(m|min|minor|M|maj|major|sus[24]|aug9?|)(?:\s)*(5|7|9|11|13|)(?:\s)*( |$)/i;

    if(/( |^)(5|7|9)( |$)/i) { ($temp, $dom, $temp2) = /( |^)(5|7|9|11|13)( |$)/i; }
    if(/( |^)(5|7|9)th( |$)/i) { ($temp, $dom, $temp2) = /( |^)(5|7|9|11|13)th( |$)/i; }

    $mod = $mod ? ($mod_hash{$mod} || '') : '';
    $key   ||= "";
    $dom   ||= "";
    $chord ||= "";

    SWITCH: {
        if ($chord eq "m" || $chord =~ /(min|minor)/i) { $chord = "min"; last SWITCH; }
        if ($chord eq "M" || $chord =~ /(maj|major)/i) { $chord = "maj"; last SWITCH; }
        if ($chord =~ /sus[24]/i) { $chord = lc $chord; last SWITCH; }
        if ($chord =~ /aug/i)     { $chord = lc $chord; last SWITCH; }
        $chord = "maj";
    }

    my $instr;
    foreach my $i (keys %instruments) {
        if(grep(/^$instruments{$i}{"names"}$/, @words)) {
            $instr = $i;
            last;
        }
    }
    
    return $instr, $chord, uc $key, $mod, $dom;
};

sub get_chord {
    my $chord = shift;
    my $mod_name = shift; # maj, 5, min, etc.
    my $chords = shift;

    foreach my $c(@$chords) {
        my @root = @{$c->{'root'}};
        if (grep(/^$chord$/, @root)) {
            my @types = @{$c->{'types'}};
            foreach my $t(@types) {
                if($t->{'name'} eq $mod_name) {
                    return(\@{$t->{'variations'}});
                }
            }
        }
    }
    return;
};

# Handle statement
handle remainder => sub {
    my ($instr_name, $chord_name, $key_name, $mod, $dom) = items($_);
    return unless $instr_name && $chord_name && $key_name;
    my $strings = $instruments{$instr_name}{"strings"};
    my $length = 4;
  
    return unless my $r = get_chord($key_name . $mod, $chord_name . $dom, $instruments{$instr_name}{"chords"});

    my @results = @{$r};
    @results = map {
    svg => gen_svg(
        'width' => 100,
        'height' => 120,
        'frets' => $length,
        'strings' => $strings,
        'points' =>  $_,
        )->xmlify,
    }, @results;
    return 'chord_diagrams', structured_answer => {
        id => 'chord_diagrams',
        name => 'Music',
        data => \@results,
        templates => {
            group => "base",
            detail => 0,
            options => {
                content => 'DDH.chord_diagrams.detail'
            },
            variants => {
                tile => 'narrow'
            }
        },
    };
    return;
};


1;
