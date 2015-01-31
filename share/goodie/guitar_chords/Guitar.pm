# Modified version of http://search.cpan.org/~taniguchi/GD-Tab-Guitar/lib/GD/Tab/Guitar.pm by Koichi Taniguchi <taniguchi@livedoor.jp>
package Guitar;
use strict;
use warnings;
use Carp;
use GD;
require "chords.pm";
use base qw(Class::Accessor::Fast);
use List::Util qw(max);

__PACKAGE__->mk_accessors(qw(bgcolor color interlaced));

our $VERSION = '0.03';
our %chord_lists;
my $SIZE = 3;
my @lines = (
    [4*$SIZE,15*$SIZE,46*$SIZE,15*$SIZE],
    [4*$SIZE,21*$SIZE,46*$SIZE,21*$SIZE],
    [4*$SIZE,27*$SIZE,46*$SIZE,27*$SIZE],
    [4*$SIZE,33*$SIZE,46*$SIZE,33*$SIZE],
    [4*$SIZE,39*$SIZE,46*$SIZE,39*$SIZE],
    [4*$SIZE,45*$SIZE,46*$SIZE,45*$SIZE],
    [4*$SIZE,15*$SIZE,4*$SIZE,45*$SIZE],
    [6*$SIZE,15*$SIZE,6*$SIZE,45*$SIZE],
    [14*$SIZE,15*$SIZE,14*$SIZE,45*$SIZE],
    [22*$SIZE,15*$SIZE,22*$SIZE,45*$SIZE],
    [30*$SIZE,15*$SIZE,30*$SIZE,45*$SIZE],
    [38*$SIZE,15*$SIZE,38*$SIZE,45*$SIZE],
);

my %synonyms = (
    'C#' => 'Db',
    'Eb' => 'D#',
    'F#' => 'Gb',
    'G#' => 'Ab',
    'Bb' => 'A#',
);

my $synonyms_re = qr<^([CFG]#|[EB]b)>;

for my $chord (keys %chord_lists) {
    if ($chord =~ $synonyms_re) {
        my $match = $1;
        (my $same_chord = $chord) =~ s/^$match/$synonyms{$match}/;
        $chord_lists{$same_chord} = $chord_lists{$chord}; # copy
    }
}

sub new {
    my $class = shift;
    bless {
        bgcolor    => [255, 255, 255],
        color      => [0, 0, 0],
        interlaced => 'true',
    }, $class;
}

sub chord {
    my ($self, $chord) = @_;
    return $self->generate($chord, $self->get_frets($chord));
}

sub get_frets {
    my ($self, $chord) = @_;
    my $frets = $chord_lists{$chord} or croak("undefined chord $chord");
    return [reverse split //, $frets];
}

sub generate {
    my ($self, $chord, $frets) = @_;
    my @frets = ref $frets eq 'ARRAY' ? @$frets : reverse split //, $frets;

    my $im = GD::Image->new(52 * $SIZE, 56 * $SIZE);
    my $bgcolor = $im->colorAllocate(@{$self->bgcolor});
    my $color = $im->colorAllocate(@{$self->color});
    $im->setThickness(2);

    if ($self->interlaced) {
        $im->transparent($bgcolor);
        $im->interlaced('true');
    }

    $self->_draw_line($im, $color);

    my $fret_max = max( grep { /^\d+$/ } @frets );

    if ($fret_max > 5) {
        $im->filledRectangle(3*$SIZE, 14*$SIZE, 6*$SIZE, 45*$SIZE, $bgcolor);
        my $fret_num = $fret_max - 5;

        for my $fret (@frets) {
            next if $fret eq 'x';
            $fret -= $fret_num;
        }

        for my $n (0..4) {
            $im->stringFT($color, "./font.ttf", 15, 0, $n * (8 * $SIZE) + 24, 53*$SIZE, $fret_num + 1);
            $fret_num++;
        }
    }
    my $i = 0;
    for my $fret (@frets) {
        if (lc $fret eq 'x') {
            $im->line(0*$SIZE, (14 + 6 * $i)*$SIZE, 2*$SIZE, (16 + 6 * $i)*$SIZE, $color);
            $im->line(2*$SIZE, (14 + 6 * $i)*$SIZE, 0, (16 + 6 * $i)*$SIZE, $color);
        } elsif ($fret > 0) {
            $im->filledRectangle(
                (9  + 8 * ($fret - 1))*$SIZE,
                (14 + 6 * $i)*$SIZE,
                (11 + 8 * ($fret - 1))*$SIZE,
                (16 + 6 * $i)*$SIZE, $color
            );
        }
        $i++;
    }

    $im->stringFT($color, "./font.ttf", 18, 0, 8, 36, $chord);
    return $im;
}

sub all_chords {
    return [keys(%chord_lists)];
}

sub _draw_line {
    my ($self, $im, $color) = @_;
    for my $line (@lines) {
        $im->line(@$line, $color);
    }
    return $im;
}

1;
