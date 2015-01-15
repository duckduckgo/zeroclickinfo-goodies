use Guitar;
#use GD::Tab::Guitar;
use IO::File;

my $gtr = Guitar->new;
#my $gtr = GD::Tab::Guitar->new;
for my $chord (@{$gtr->all_chords}) {
    my $filename = $chord;
    my $file = IO::File->new("$filename.png", 'w');
    $gtr->color(51, 51, 51);
    $file->print($gtr->chord($chord)->png);
}
