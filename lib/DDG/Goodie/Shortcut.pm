package DDG::Goodie::Shortcut;
# ABSTRACT: Display keyboard shortcut for an action or display action invoked by a key combination.

use DDG::Goodie;

triggers any => 'shortcut','keyboard shortcut';

zci is_cached => 1;
zci answer_type => 'shortcut';

primary_example_queries   "rename shortcut";
secondary_example_queries "f11 shortcut", "paste shortcut";
description "keyboard shortcuts";
name "Shortcut";
topics "computing";
category "computing_info";
attribution github => ['https://github.com/dariog88a','dariog88a'],
            twitter => ['http://twitter.com/dariog88','dariog88'];

# not using query_lc because I need to keep the whitespace
handle remainder => sub {

    my $search = lc $_;

    my %keys = (
        'undo' => 'ctrl z',
        'redo' => 'ctrl y', #[qw('ctrl y' 'ctrl shift z')],
        'cut' => 'ctrl x',
        'copy' => 'ctrl c',
        'paste' => 'ctrl v',
        'select all' => 'ctrl a',
        'new' => 'ctrl n',
        'open' => 'ctrl o',
        'close' => 'alt f4',
        'save' => 'ctrl s',
        'print' => 'ctrl p',
        'bold' => 'ctrl b',
        'italic' => 'ctrl i',
        'underline' => 'ctrl u',
        'help' => 'f1',
        'rename' => 'f2',
        'find' => 'f3', #[qw('f3' 'ctrl f')],
        'refresh' => 'f5',
        'reload' => 'ctrl r',
        'address bar' => 'f6',
        'location bar' => 'ctrl l',
        'fullscreen' => 'f11'
    );
    my %actions = reverse %keys;

    my @answer;
    my $char;
    if (exists $actions{$search}) {
        @answer = split(' ',$actions{$search});
        $char = ' ';
    }

    if (exists $keys{$search}) {
        @answer = split(' ',$keys{$search});
        $char = '+';
    }

    foreach(@answer) {
        $_ = ucfirst $_;
    }

    return join($char,@answer) if @answer;
    return;
};

1;
