package DDG::Goodie::FIGlet;
# ABSTRACT: Uses FIGlet to make large letters out of ordinary text.

use DDG::Goodie;
use Text::FIGlet;

triggers query => qr/^(?:figlet|bigtext)(?:\-|\s+)(.*)/;
primary_example_queries 'figlet DuckDuckGo';
secondary_example_queries 'figlet computer DuckDuckGo';

name 'FIGlet';
description 'Uses FIGlet to make large letters out of ordinary text.';
category 'transformations';
topics 'words_and_games';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Figlet.pm';
attribution
    web => ['http://engvik.nu', 'Lars Jansøn Engvik'],
    github => [ 'larseng', 'Lars Jansøn Engvik'];

zci answer_type => 'figlet';
zci is_cached => 1;

my $width = 60;

# Fetch available fonts.
opendir DIR, share();
my @fonts = readdir(DIR);
closedir DIR;

# Renders a figlet.
sub render_figlet {
    my ($font, $text) = @_;

    if ($font) {
        return Text::FIGlet->new(-f=>$font, -d=>share())->figify(-w=>$width, -A=>$text);
    } else {
        return Text::FIGlet->new(-d=>share())->figify(-w=>$width, -A=>$text);
    }
}

handle query => sub {
    my $font;
    my $text;
    my $figlet;


    # Check for a font indication in the query.
    $text = $1;
    $1 =~ m/^\s*(\w+)/;
    $font = lc $1 if grep /\b$1\b/i, @fonts;

    # Strip the font from the text to render if we're using a font.
    if ($font && $font ne $text) {
        $text = substr $text, length ($font)+1, length $text;
    } else {
        $font = "standard";
    }
    
    # Render the FIGlet
    $figlet = render_figlet($font, $text);

    return $figlet, html => "<pre>$figlet</pre><span>&quot;$text&quot; rendered in FIGlet font &quot;$font&quot;.</span>" if $figlet;
    return;
};

1;
