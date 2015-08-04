package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files

use JSON::XS;
use DDG::Goodie;
use Text::Trim;

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

sub get_json_path {
    my $name = lc shift;
    return share(join('-', split /\s+/o, "$name.json"));
}

handle remainder => sub {

    # If needed we could jump through a few more hoops to check
    # terms against file names.
    my $json_path = get_json_path($_);
    my $fh;

    # try to open file, may need to cleanup candidate filename
    unless (open $fh, $json_path){ 
        # allow queries like "cheat sheet for vim"
        s/^for\s+//;
        trim($_);
        $json_path = get_json_path($_);
        open $fh, $json_path or return;
    }

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
