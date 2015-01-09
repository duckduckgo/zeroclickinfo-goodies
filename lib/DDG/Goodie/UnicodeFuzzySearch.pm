package DDG::Goodie::UnicodeFuzzySearch;
# ABSTRACT: returns unicode symbols matching the input

use DDG::Goodie;
use URI::Escape::XS;

triggers startend => "unicode", "emoji";

zci is_cached => 1;

attribution
    github => ["konr", 'Konrad Scorciapino'],
    twitter => ["konr", 'Konrad Scorciapino'],
    web => ["http://konr.mobi", 'Konrad Scorciapino'];
primary_example_queries 'unicode black heart';
secondary_example_queries "unicode 2665";

name 'Reverse Unicode Search';
description 'returns unicode symbols matching the input';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UnicodeReverse.pm';
category 'computing_info';
topics 'programming';

# UnicodeData.txt is a semicolon-separated file.
# Uploaded file version: 6.3.0, obtained from
# ftp://ftp.unicode.org/Public/6.3.0/ucd/
my @lines = split /\n/, share("UnicodeData.txt")->slurp;

use constant {
    IMAGE_PROXY       => '/iu/?u=',
    EMOJI_IMAGE_PATH  => 'http://www.emoji-cheat-sheet.com/graphics/emojis/<PATH>.png',
    EMOJI_LOWER_BOUND => 0x1F300,
    EMOJI_UPPER_BOUND => 0x1F6C5,
    EMOJI_IMAGE_SIZE  => 20
};

handle remainder => sub {
    return unless $_;
    my $pattern = uc join('.*', $_);

    # 1st column = number ; 2nd column = name. See
    # http://www.unicode.org/draft/ucd/UnicodeData.html
    my @matches;

    # AS FUZZY AS POSSIBLE BUT NOT MORE - It's either (a) number (no ';'
    # before) or (b) part of the name or, when there are way too many
    # matches for the result to be helpful, (c) isolated words.
    @matches = grep { /^[^;]*;?[^;]*$pattern/ } @lines;
    @matches = grep { /\b$pattern\b/ } @lines if (scalar @matches >= 50);

    return unless (scalar @matches > 0 && scalar @matches < 50);

    @matches = map {
        (my $code, my $name) = split /;/;
        {symbol => chr(hex($code)),
         code => $code,
         name => $name};
    } @matches;

    my @results = map { _make_a_result($_) } @matches;

    my $html = scalar @results > 1 ?
		'<ul>' . join('', map {"<li>$_</li>"} @results) . '</ul>' : $results[0];

    return join("\n", @results), html => $html;

};

sub _make_a_result {
    my ( $obj ) = @_;

    my $decimal_code = hex $obj->{code};
    my $symbol = $obj->{symbol};

    # If the code is a emoji icon, we'll serve it as a image instead
    # because it's rendered properly on Chrome.
    if( EMOJI_LOWER_BOUND <= $decimal_code && $decimal_code <= EMOJI_UPPER_BOUND  ) {
        ( my $image_name = lc $obj->{name} ) =~ s/\s/_/g;
        ( my $image_path = EMOJI_IMAGE_PATH ) =~ s/<PATH>/$image_name/;
        $symbol = sprintf(
            '<img src="%s" alt="%s" width="%s" style="vertical-align:bottom"/>',
            IMAGE_PROXY . encodeURIComponent( $image_path ),
            $symbol,
            EMOJI_IMAGE_SIZE,
        );
    }

    return sprintf('%s: %s (U+%s)', $obj->{name}, $symbol, $obj->{code} );
};

1;
