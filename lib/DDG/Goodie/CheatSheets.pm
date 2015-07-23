package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files

use JSON::XS;
use DDG::Goodie;
use DDP;

zci answer_type => 'cheat_sheet';
zci is_cached   => 1;

triggers startend => (
    'char', 'chars',
    'character', 'characters',
    'cheat sheet', 'cheatsheet',
    'command', 'commands',
    'example', 'examples',
    'guide', 'help',
    'quick reference', 'reference',
    'shortcut', 'shortcuts',
    'symbol', 'symbols',
    'key bindings', 'keys', 'default keys'
);

# Accepts the json cheatsheet file name and an array of everything
# that should be aliased with the json file
sub build_aliases {
    my ($json, @aliases) = @_;
    my @result = ();
    
    foreach (@aliases) {
        push (@result, $_);
        push (@result, $json);
    }
    
    return @result;
}

# The hash of all aliases
my %alias = (
    build_aliases('microsoft-windows.json', (
        'windows', 'windows xp', 'windows vista', 'windows 7', 'windows 8',
        'microsoft windows xp', 'microsoft windows vista', 'microsoft windows 7', 'microsoft windows 8'
    )),
    build_aliases('sublime-text.json', (
        'sublime', 'sublime text 2', 'sublime 2'
    ))
);

handle remainder => sub {
    # If needed we could jump through a few more hoops to check
    # terms against file names.
    
    my $json_path;
    
    if ($alias{lc($_)}) {
        $json_path = share($alias{lc($_)});
    } else {
        $json_path = share(join('-', split /\s+/o, lc($_) . '.json'));
    }

    open my $fh, $json_path or return;
    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json);

    return 'Cheat Sheet', structured_answer => {
        id => 'cheat_sheets',
        dynamic_id => $data->{id},
        name => 'Cheat Sheet',
        data => $data,
        templates => {
            group => 'base',
            item => 0,
            options => {
                content => 'DDH.cheat_sheets.detail',
                moreAt => 0
            }
        }
    };
};

1;
