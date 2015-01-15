package DDG::Goodie::GuitarChords;
# ABSTRACT: Returns diagrams of guitar chords

use DDG::Goodie;
with 'DDG::GoodieRole::ImageLoader';

# guitar script is stored in share directory
# including this way, because it limits duplicated code
my $g = share("Guitar.pm");
require "$g";

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
            html => "<div class='text--secondary'>Guitar chord diagram for $c</div>" . get_chord_img($c),
            answer => "$c";
    }
    return;
};

my $gtr = Guitar->new;

sub check_chord
{
    if ($_[0] =~ /(?<a>[a-gA-G])(?<b>#|b)?(?<c>dim|min|maj|add|aug|m|M)?(?<d>M|maj|m|min)?(?<e>[0-9])?\s*(?<f>(#|b)?[0-9]+)?/) {
        my ($a,$b,$c,$d,$e,$f,$r) = "";
        $a = uc($+{'a'});
        if ($+{'b'}) {
            $b = $+{'b'} if $+{'b'};
        }
        if (my $m = $+{'c'}) {
            $c = 'm' if ($m =~ /^(min|m)$/);
            $c = 'M' if ($m =~ /^(maj|M)$/);
        }
        if (my $m = $+{'d'}) {
            $d = 'm' if ($m =~ /^(min|m)$/);
            $d = 'M' if ($m =~ /^(maj|M)$/);
        }
        $e = $+{'e'} if $+{'e'};
        $f = '('.$+{'f'}.')' if $+{'f'};
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
