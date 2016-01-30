package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files

use JSON::XS;
use DDG::Goodie;
use DDP;
use File::Find::Rule;
use List::Util qw(any);
use List::MoreUtils qw(uniq);

no warnings 'uninitialized';

zci answer_type => 'cheat_sheet';
zci is_cached   => 1;

sub maybe_plural {
    my $phrase = shift;
    return ($phrase, $phrase . 's');
}

my %standard_triggers = (
    'keyboard' => [
        'quick reference',
        'reference',
        maybe_plural('shortcut'),
        'key bindings',
        'keys',
        'default keys',
    ],
    'reference' => [
        'quick reference',
        'reference',
    ],
    'terminal' => [
        maybe_plural('char'),
        maybe_plural('character'),
        maybe_plural('command'),
        maybe_plural('symbol'),
    ],
    'language' => [
        'guide',
        maybe_plural('example'),
    ],
    'code' => [
        'quick reference',
        'reference',
    ],
);

# All cheat sheets are triggered by these.
my @all_triggers = (
    'help',
    'cheat sheet',
    'cheatsheet',
);

sub generate_triggers {
    my @triggers = @all_triggers;
    foreach my $trigger_set (values %standard_triggers) {
        push @triggers, @{$trigger_set};
    }
    return uniq @triggers;
}

triggers startend => generate_triggers();


sub getAliases {
    my @files = File::Find::Rule->file()
                                ->name("*.json")
                                ->in(share());
    my %results;

    foreach my $file (@files) {
        open my $fh, $file or warn "Error opening file: $file\n" and next;
        my $json = do { local $/;  <$fh> };
        my $data = eval { decode_json($json) } or do {
            warn "Failed to decode $file: $@";
            next;
        };

        my $defaultName = File::Basename::fileparse($file);
        $defaultName =~ s/-/ /g;
        $defaultName =~ s/.json//;

        $results{$defaultName} = $file;

        if ($data->{'aliases'}) {
            foreach my $alias (@{$data->{'aliases'}}) {
                $results{lc($alias)} = $file;
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
    unless (any { $_ eq $req->matched_trigger } @all_triggers) {
        my $template_type = $data->{template_type};
        my @triggers = @{$standard_triggers{$template_type}};
        return unless any { $_ eq $req->matched_trigger } @triggers;
    };

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
