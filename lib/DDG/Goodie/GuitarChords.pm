package DDG::Goodie::GuitarChords;
# ABSTRACT: Returns diagrams of guitar chords

use DDG::Goodie;
use strict;
with 'DDG::GoodieRole::ImageLoader';

# guitar script is stored in share directory
# including this way, because it limits duplicated code
my $g = share("chords.pm");
do "$g";
our %chord_lists; #from chords.pm

zci answer_type => 'guitarchord';
zci is_cached => 1;

triggers startend => ('guitar chord');

handle remainder => sub
{
    if (my $c //= check_chord($_))
    {
        my $f = $c;
        # filenames use '_' instead of parenthesies
        $f =~ s/[\(\)]/_/g;
        $f =~ s/([^dim])m/$1minor/g;
        $f =~ s/M/major/g;

        return
            heading => "$c",
            answer => "$c",
            html => "<div class='text--secondary'>Guitar chord diagram for $c</div>" . get_chord_img($f);
    }
    return;
};

# Checks a chord to make sure it's valid and formats it so
# that it will match a filename in the share directory.
sub check_chord
{
    if ($_[0] =~ /^(?<a>[a-gA-G])(?<b>#|b)?\s*(?<c>dim|min|maj|add|aug|m|M)?\s*(?<d>M|maj|m|min)?(?<e>[0-9]?(sus[0-9])?)?(\/(?<f>(#|b)?[0-9]+))?$/) {
        my ($a,$b,$c,$d,$e,$f,$r);
        $a = uc($+{'a'});
        $b = $+{'b'} if $+{'b'};
        if ($c = $+{'c'}) {
            $c = 'm' if ($c =~ /^(min|m)$/);
            $c = 'M' if ($c =~ /^(maj|M)$/);
        }
        if ($d = $+{'d'}) {
            $d = 'm' if ($d =~ /^(min|m)$/);
            $d = 'M' if ($d =~ /^(maj|M)$/);
        }
        $e = $+{'e'} if $+{'e'};
        $f = '('.$+{'f'}.')' if $+{'f'};
        $r = $a if $a;
        $r .= $b if $b;
        $r .= $c if $c;
        $r .= $d if $d;
        $r .= $e if $e;
        $r .= $f if $f;
        if (exists($chord_lists{$r})) {
            return $r;
        }
    }
    return;
}

# Returns an image tag with the correct filename and width.
sub get_chord_img
{
    goodie_img_tag({filename=>$_[0].'.png', width=>78});
}

1;
