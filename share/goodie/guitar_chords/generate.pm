use GD::Tab::Guitar;
use IO::File;

my $gtr = GD::Tab::Guitar->new;
for my $chord (@{$gtr->all_chords}) {
    my $filename = $chord;
    my $file = IO::File->new("$filename.png", 'w');
    $file->print($gtr->chord($chord)->png);
}
