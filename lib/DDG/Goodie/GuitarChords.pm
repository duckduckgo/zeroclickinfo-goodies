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
    if ($_[0] =~ /(?<a>[a-gA-G])(?<b>#|b)?(?<c>dim|m|min|aug|add)?(?<d>M|maj|m|min)?(?<e>[0-9])?\s*(?<f>(#|b)?[0-9]+)?/) {
        my ($a,$b,$c,$d,$e,$f,$r) = "";
        $a = uc($+{'a'}) if $+{'a'};
        if ($+{'b'}) {
            $b = $+{'b'} if $+{'b'};
        }
        if ($+{'c'}) {
            $c = 'm' if ($+{'c'} =~ /(min|m)/);
        }
        if ($+{'d'}) {
            $d = 'M' if ($+{'d'} =~ /(maj|M)/);
        }
        if ($+{'e'}) {
            $e = $+{'e'};
        }
        if ($+{'f'}) {
            $f = '('.$+{'f'}.')';
        }
        # 'cause perl will throw `$c is not defined` even though $c is initialized to an empty string?
        $r = $a if $a;
        $r .= $b if $b;
        $r .= $c if $c;
        $r .= $d if $d;
        $r .= $e if $e;
        $r .= $f if $f;
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
