package DDG::Goodie::FIGlet;
# ABSTRACT: Uses FIGlet to make large letters out of ordinary text.

use DDG::Goodie;
use Text::FIGlet;

triggers startend => 'figlet';
primary_example_queries 'figlet DuckDuckGo';
secondary_example_queries 'figlet graceful DuckDuckGo';

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

my @fonts = share()->children;
my $figlet;
my $width = 60;

handle remainder => sub {
    m/^\s*(\w+)/;

    # Checks if the first word is a font and uses it if it's not the only
    # word to figify. Else uses the standard font.
    if ($1 && $_ ne $1 && grep /\b$1\b/i, @fonts) {
        $figlet = Text::FIGlet->new(-f=>lc $1, -d=>share())->figify(-w=>$width, -A=>substr $_, length($1)+1, length $_);
    } elsif ($_) {
        $figlet = Text::FIGlet->new(-d=>share())->figify(-w=>$width, -A=>$_);
    }
    
    return $figlet, html => "<pre>$figlet</pre>" if $figlet;
    return;
};

1;
