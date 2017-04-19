package DDG::Goodie::Fontawesome;

# ABSTRACT: List of Fontawesome icons
use strict;
use DDG::Goodie;

zci answer_type => "fontawesome";
zci is_cached   => 1;

triggers startend => (
    'fa cheat sheet','fontawesome','fontawesome icons','fontawesome icon','fa icons','fontawesome cheat sheet'
);

my $HTML = share("fontawesome.html")->slurp(iomode => '<:encoding(UTF-8)');

handle remainder => sub {
    return
        heading => 'FontAwesome Icons',
        html    => $HTML,
        answer  => $HTML,
};

1;