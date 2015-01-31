package DDG::Goodie::Shortcut;
# ABSTRACT: Display keyboard shortcut for an action.

use DDG::Goodie;
use utf8;

triggers any => 'shortcut','keyboard shortcut', 'key combination';

zci answer_type => 'shortcut';
zci is_cached   => 1;

primary_example_queries 'windows show desktop shortcut';
secondary_example_queries 'ubuntu shortcut new folder';
description 'Keyboard shortcuts';
name 'Shortcut';
topics 'computing';
category 'computing_info';
attribution github => ['dariog88a','Darío'],
            email => [ 'dariog88@gmail.com', 'Darío' ],
            twitter => ['dariog88', 'Darío'];

my @shortcuts = share('shortcuts.csv')->slurp(iomode => '<:encoding(UTF-8)');

handle remainder_lc => sub {
    #keep only letters and spaces (remove versioning)
    s/[^a-z ]//gi;
    #replace all OS words with starting char
    s/windows|win|xp|vista|seven|eight/W/gi;
    s/mac|os[ ]*x/M/gi;
    s/linux|ubuntu|debian|fedora|kde|gnome/L/gi;

    #get OS char (if any)
    my $search = $_;
    $search =~ /(W|M|L)/;
    my $os = $1; #save OS char
    $search =~ tr/[WML]//d; #remove all OS chars from search
    $search =~ tr/ / /s; #leave just one blank between words
    $search =~ s/^\s+|\s+$//g; #trim

if(!$os) {$os='';} #line added to avoid error, remove when UA detection added.

    my $line;
    foreach (@shortcuts) {
        if($_ =~ /^$search/i) { #matches only the start
            $line = $_;
            $line =~ s/\R//g; #remove carriage return
            last;
        }
    }

    return if !$line;

    my @columns = split('\|',$line);
    my $answer = 'The shortcut for ' . $columns[0];
    my %systems = (W=>'Windows',M=>'Mac OS',L=>'KDE/GNOME');
    my %keys = (W => $columns[1], M => $columns[2], L => $columns[3]);

    return if !$keys{$os};

    if ($os) { $answer .= ' in ' . $systems{$os} . ' is ' . $keys{$os}; }

    my $source = '<br/><a href="https://en.wikipedia.org/wiki/Table_of_keyboard_shortcuts">More at Wikipedia</a>';
    return $answer, html => "$answer $source";
};

1;
