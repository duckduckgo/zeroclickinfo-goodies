package DDG::Goodie::GuitarChords;
# ABSTRACT: Returns diagrams of guitar chords

use DDG::Goodie;
with 'DDG::GoodieRole::ImageLoader';

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
    if (my $c //= check_chord($_))
    {
        return
            heading => "$c",
            html => get_chord_img($c),
            answer => "$c";
    }
    return;
};

my $gtr = GD::Tab::Guitar->new;

sub check_chord
{
    if ($_[0] =~ /([a-gA-G])(#|b)?(dim|m|min|aug|add)?(M|maj|m|min)?([0-9])?\s*((#|b)?[0-9]+)?/) {
        my $r = "";
        $r .= uc($1) if $1;
        $r .= $2 if $2;
        if ($3) {
            if($3 eq "min") {
                $r .= "m";
            } else {
                $r .= $3;
            }
        }
        if ($4) {
            if ($4 eq "maj") {
                $r .= "M";
            } elsif ($4 eq "min") {
                $r .= "m";
            }
        }
        $r .= $5 if defined $5;
        if ($6) {
            $r .= '('.$6.')';
        }
        if ($r ~~ @{$gtr->all_chords}) {
            return $r;
        }
    }
    return;
}

sub get_chord_img
{
    goodie_img_tag({filename=>$_[0].'.png'});
}

1;
