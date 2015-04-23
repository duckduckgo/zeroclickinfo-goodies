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
);

handle remainder => sub {
    # If needed we could jump through a few more hoops to check
    # terms against file names.
    my $json_path = share(join('-', split /\s+/o, lc($_) . '.json'));
    open my $fh, $json_path or return;
    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json);

    return 'Cheat Sheet', structured_answer => {
        dynamic_id => $data->{id},
        name => 'Cheat Sheet',
        data => $data,
        meta => \%{$data->{meta}},
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
