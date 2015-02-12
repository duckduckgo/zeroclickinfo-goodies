use Guitar;
use IO::File;

my $gtr = Guitar->new;
for my $chord (@{$gtr->all_chords}) {
    my $filename = "$chord.png";
    $filename =~ s/[\(\)]/_/g;
    my $file = IO::File->new($filename, 'w');
    $gtr->color(51, 51, 51);
    $file->print($gtr->chord($chord)->png);
}
