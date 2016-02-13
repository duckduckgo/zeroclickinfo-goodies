package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files

use JSON::XS;
use DDG::Goodie;
use DDP;
use File::Find::Rule;

no warnings 'uninitialized';

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

sub getAliases {
    my @files = File::Find::Rule->file()
                                ->name("*.json")
                                ->in(share());
    my %results;
    my $cheat_dir = File::Basename::dirname($files[0]);

    foreach my $file (@files) {
        open my $fh, $file or warn "Error opening file: $file\n" and next;
        my $json = do { local $/;  <$fh> };
        my $data = eval { decode_json($json) } or do {
            warn "Failed to decode $file: $@";
            next;
        };

        my $name = File::Basename::fileparse($file);
        my $defaultName = $name =~ s/-/ /gr;
        $defaultName =~ s/.json//;

        $results{$defaultName} = $file;

        if ($data->{'aliases'}) {
            foreach my $alias (@{$data->{'aliases'}}) {
                my $lc_alias = lc $alias;
                if (defined $results{$lc_alias}
                    && $results{$lc_alias} ne $file) {
                    my $other_file = $results{$lc_alias} =~ s/$cheat_dir\///r;
                    die "$name and $other_file both using alias '$lc_alias'";
                }
                $results{$lc_alias} = $file;
            }
        }
    }
    return \%results;
}

my $aliases = getAliases();

handle remainder => sub {
    # If needed we could jump through a few more hoops to check
    # terms against file names.
    open my $fh, $aliases->{join(' ', split /\s+/o, lc($_))} or return;

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
                content => "DDH.cheat_sheets.detail",
                moreAt => 0
            }
        }
    };
};

1;
