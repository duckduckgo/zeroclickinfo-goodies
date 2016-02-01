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
    'math' => [
        maybe_plural('equation'),
        maybe_plural('formula'),
        'formulae',
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
    my ($options, $type, $triggers) = @_;
    my $existing = $additional_triggers{$type};
    $triggers = [$triggers] unless ref $triggers eq 'ARRAY';
    foreach my $trigger (@{$triggers}) {
        if (any { $_ eq $trigger } @{$existing}) {
            die "Trigger '$trigger' already in use!\n";
        };
    };
    my @new_triggers = (@{$existing}, @{$triggers});
    $additional_triggers{$type} = \@new_triggers;
    @trigger_lookup{@{$triggers}} = map { $options } (1..@{$triggers});
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
            my $options = {
                file => $file,
            };
            if ($data->{triggers}->{options}) {
                my $trigger_options = delete $data->{triggers}->{options};
                my %new_options = (%{$trigger_options}, %{$options});
                $options = \%new_options;
            };
            while (my ($type, $triggers) = each $data->{triggers}) {
                my %options = %{$options};
                add_triggers(\%options, $type, $triggers);
            };
        };

        if ($data->{'aliases'}) {
            foreach my $alias (@{$data->{'aliases'}}) {
                my $lc_alias = lc $alias;
                if (defined $results{$lc_alias}) {
                    ($lc_alias eq $defaultName)
                        ?  warn "Aliases should not contain the cheat sheet name ($defaultName) in $file"
                        :  die "Name already in use '$lc_alias' in $file";
                };
                $results{$lc_alias} = $file;
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
    my $who = $trigger_lookup{$trigger};
    my $file = $aliases->{join(' ', split /\s+/o, lc($remainder))};
    if (defined $who) {
        return (1, $who->{file}) unless $who->{require_name};
        return (1, $file) if $file eq $who->{file};
    } else {
        return (0, $file);
    };
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
        id         => 'cheat_sheets',
        dynamic_id => $data->{id},
        name       => 'Cheat Sheet',
        data       => $data,
        templates  => {
            group   => 'base',
            item    => 0,
            options => {
                content => "DDH.cheat_sheets.detail",
                moreAt  => 0
            }
        }
    };
};

1;
