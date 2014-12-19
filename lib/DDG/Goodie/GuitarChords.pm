package DDG::Goodie::GuitarChords;
# ABSTRACT: Returns diagrams of guitar chords

use DDG::Goodie;
use MIME::Base64;
use GD::Tab::Guitar;

zci answer_type => 'guitarchord';
zci is_cached => 1;

name "GuitarChords";
description "Returns diagrams of guitar chords";
category "reference";
topics "music";

primary_example_queries 'G#m6 guitar chord', 'G guitar chord', 'Dbdim guitar chord';

attribution github  => ["charles-l",                  "Charles Saternos"],
            twitter => ["theninjacharlie",            "Charles Saternos"],
            web     => ["http://charels-l.github.io", "Charles Saternos"];

triggers startend => ('guitar chord');

handle remainder => sub
{
    if (my $c //= parse_chord($_))
    {
        return
            heading => "$c",
            html => "<img src='data:image/png;base64,".generate_img($c)."'/>",
            answer => "$c"
    }
    return;
};

my $gtr = GD::Tab::Guitar->new;

sub parse_chord
{
    if ($_[0] =~ /^([A-Ga-g])(#|b)?(dim|m)?([0-9])?$/) {
        my $r = "";
        $r .= ucfirst($1) if $1;
        $r .= $2 if $2;
        if ($3) {
            if($3 eq "m") {
                $r .= "m";
            } elsif (lc $3 eq "dim") {
                $r .= "dim";
            }
        }
        $r .= $4 if defined $4;
        if ($_[0] ~~ @{$gtr->all_chords}) {
            return $r;
        }
    }
    return;
}
sub generate_img
{
    return MIME::Base64::encode_base64($gtr->chord($_[0])->png);
}

1;
