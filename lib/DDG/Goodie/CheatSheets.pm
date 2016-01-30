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

sub generate_standard_triggers {
    my @triggers = @all_triggers;
    foreach my $trigger_set (values %standard_triggers) {
        push @triggers, @{$trigger_set};
    }
    return uniq @triggers;
}

my %additional_triggers = (
    any      => [],
    end      => [],
    start    => [],
    startend => [],
);

# Used for determining who triggered something.
my %trigger_lookup = ();

sub add_triggers {
    my ($name, $type, $triggers) = @_;
    my $existing = $additional_triggers{$type};
    foreach my $trigger (@{$triggers}) {
        if (any { $_ eq $trigger } @{$existing}) {
            die "Trigger '$trigger' already in use!\n";
        };
    };
    my @new_triggers = (@{$existing}, @{$triggers});
    $additional_triggers{$type} = \@new_triggers;
    @trigger_lookup{@{$triggers}} = $name;
}

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

        if ($data->{triggers}) {
            while (my ($type, $triggers) = each $data->{triggers}) {
                add_triggers($file, $type, $triggers);
            };
        };

        if ($data->{'aliases'}) {
            foreach my $alias (@{$data->{'aliases'}}) {
                $results{lc($alias)} = $file;
            }
        }
    }
    return \%results;
}

my $aliases = getAliases();

triggers any      => @{$additional_triggers{any}}
    if $additional_triggers{any};
triggers end      => @{$additional_triggers{end}}
    if $additional_triggers{end};
triggers start    => @{$additional_triggers{start}}
    if $additional_triggers{start};
triggers startend => (
    generate_standard_triggers(),
    @{$additional_triggers{startend}}
);

# (was custom trigger?, trigger file)
sub who_triggered {
    my ($remainder, $trigger) = @_;
    return (1, $trigger_lookup{$trigger})
        if defined($trigger_lookup{$trigger});
    return (0, $aliases->{join(' ', split /\s+/o, lc($remainder))});
}

handle remainder => sub {
    my $remainder = shift;
    # If needed we could jump through a few more hoops to check
    # terms against file names.
    my ($was_additional, $who) = who_triggered($remainder, $req->matched_trigger);
    open my $fh, $who or return;

    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json);
    unless ($was_additional || any { $_ eq $req->matched_trigger } @all_triggers) {
        my $template_type = ($data->{template_type});
        my @categories = ($template_type);
        push @categories, @{$data->{additional_categories}}
            if defined $data->{additional_categories};
        my $matched = 0;
        foreach my $category (@categories) {
            my @triggers = @{$standard_triggers{$category}};
            if (any { $_ eq $req->matched_trigger } @triggers) {
                $matched = 1;
                last;
            };
        };
        return unless $matched;
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
