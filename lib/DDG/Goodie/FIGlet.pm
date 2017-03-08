package DDG::Goodie::FIGlet;
# ABSTRACT: Uses FIGlet to make large letters out of ordinary text.

use strict;
use utf8;
use DDG::Goodie;
use Text::FIGlet;

triggers startend => "figlet", "bigtext", "big text";

zci answer_type => 'figlet';
zci is_cached => 1;

my $width = 800;

# Fetch available fonts.
opendir DIR, share();
my @fonts = readdir(DIR);
closedir DIR;

# Renders a figlet.
sub render_figlet {
    my ($font, $text) = @_;
    return Text::FIGlet->new(-f=>$font, -d=>share())->figify(-w=>$width, -A=>$text);
}

handle query => sub {
    my $font;
    my $text;
    my $figlet;

    # Return if no input provided.
    return if ((lc $_ eq 'figlet') || (lc $_ eq 'bigtext') || (lc $_ eq 'big text'));

    # Parse query.
    $_ =~ m/^(?:figlet|bigtext|big text)(?:\-|\s+)(.*)|(.*)\s+(?:figlet|bigtext|big text)$/i;
    $text = $1 if $1;
    $text = $2 if $2;

    # Checks if the first word is a font.
    $text =~ m/^\s*(\w+)/;
    $font = lc $1 if grep /\b$1\b/i, @fonts;

    # Strip the font from the text to render if we're using a font.
    if ($font && $font ne $text) {
        $text = substr $text, length ($font)+1, length $text;
    } else {
        $font = "standard";
    }

    # Render the FIGlet
    $figlet = render_figlet($font, $text);

    return unless $figlet;
    
    return $figlet,
    structured_answer => {
        data => {
            title => $figlet,
            subtitle => "Font: $font",
        },
        templates => {
            group => 'text',
        }
    };
};

1;
