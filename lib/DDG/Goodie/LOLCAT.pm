package DDG::Goodie::LOLCAT;
# ABSTRACT: Convert submitted text to LOLCAT language
# Parts of the script were copied from Acme::LOLCAT on CPAN 

use DDG::Goodie;

zci answer_type => "lolcat";
zci is_cached   => 1;

# Metadata.
name "LOLCAT";
description "Convert text to LOLCAT language";
primary_example_queries "lolcat have cheeseburger";
category "entertainment";
topics "geek", "special_interest", "words_and_games";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/LOLCAT/LOLCAT.pm";
attribution github => ["JohnCarlosReed", "John Reed"],
            twitter => "johnnycarlos";

my %repl = (
    what     => [qw/wut whut/],   'you\b'   => [qw/yu yous yoo u/],
    cture    => 'kshur',          unless    => 'unles',
    'the\b'  => 'teh',            more      => 'moar',
    my       => [qw/muh mah/],    are       => [qw/r is ar/],
    eese     => 'eez',            ph        => 'f',
    'as\b'   => 'az',             seriously => 'srsly',
    'er\b'   => 'r',              sion      => 'shun',
    just     => 'jus',            'ose\b'   => 'oze',
    eady     => 'eddy',           'ome?\b'  => 'um',
    'of\b'   => [qw/of ov of/],   'uestion' => 'wesjun',
    want     => 'wants',          'ead\b'   => 'edd',
    ucke     => [qw/ukki ukke/],  sion      => 'shun',
    eak      => 'ekk',            age       => 'uj',
    like     => [qw/likes liek/], love      => [qw/loves lub lubs luv/],
    '\bis\b' => ['ar teh','ar'],  'nd\b'   => 'n',
    who      => 'hoo',            q(')      => q(),
    'ese\b'  => 'eez',            outh      => 'owf',
    scio     => 'shu',            esque     => 'esk',
    ture     => 'chur',           '\btoo?\b'=> [qw/to t 2 to t/],
    tious    => 'shus',           'sure\b'  => 'shur',
    'tty\b'  => 'tteh',           were      => 'was',
    'ok\b'   => [ qw/'k kay/ ],   '\ba\b'   => q(),
    ym       => 'im',             'thy\b'   => 'fee',
    '\wly\w' => 'li',             'que\w'   => 'kwe',
    oth      => 'udd',            ease      => 'eez',
    'ing\b'  => [qw/in ins ng ing/],
    'have'   => ['has', 'hav', 'haz a'],
    your     => [ qw/yur ur yore yoar/ ],
    'ove\b'  => [ qw/oov ove uuv uv oove/ ],
    for      => [ qw/for 4 fr fur for foar/ ],
    thank    => [ qw/fank tank thx thnx/ ],
    good     => [ qw/gud goed guud gude gewd/ ],
    really   => [ qw/rly rily rilly rilley/ ],
    world    => [ qw/wurrld whirld wurld wrld/ ],
    q(i'?m\b)     => 'im',
    '(?!e)ight'   => 'ite',
    '(?!ues)tion' => 'shun',
    q(you'?re)    => [ qw/yore yr/ ],
    '\boh\b(?!.*hai)'  => [qw/o ohs/],
    'can\si\s(?:ple(?:a|e)(?:s|z)e?)?\s?have\sa' => 'i can has',
    '(?:hello|\bhi\b|\bhey\b|howdy|\byo\b),?'    => 'oh hai,',
    '(?:god|allah|buddah?|diety)'                => 'ceiling cat',
);


# Triggers
triggers start => "lolcat";                                                                                                                                                    

# Handle statement
handle remainder => sub {

    return unless $_; # Guard against "no answer"

    return translate( $_ );
};


# Translate string to LOLCAT language
sub translate {
    my $phrase = lc shift;

    $phrase =~ s{
                  $_
                }
                {
                  ref $repl{ $_ } eq 'ARRAY'
                    ? $repl{ $_ }->[ rand( $#{ $repl{ $_ } } + 1 ) ]
                    : $repl{ $_ }
                }gex
                for keys %repl;

    $phrase =~ s/\s{2,}/ /g;
      $phrase =~ s/teh teh/teh/g; # meh, it happens sometimes.
      $phrase .= '.  kthxbye!' if( int rand 10 == 2 );
      $phrase .= '.  kthx.'    if( int rand 10 == 1 );
      $phrase =~ s/(\?|!|,|\.)\./$1/;
      return uc $phrase;
}


1;
