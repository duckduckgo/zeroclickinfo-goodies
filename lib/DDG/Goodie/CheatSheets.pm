package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files

use JSON::XS;
use DDG::Goodie;
use DDP;
use File::Find::Rule;
use JSON;

no warnings 'uninitialized';

zci answer_type => 'cheat_sheet';
zci is_cached   => 1;

my $triggers_json = share('triggers.json')->slurp();
my %standard_triggers = %{decode_json($triggers_json)};

# All cheat sheets are triggered by these.
my %all_triggers;
@all_triggers{(
    'help',
    'cheat sheet',
    'cheatsheet'
)} = undef;

sub generate_standard_triggers {
    my %triggers;
    @triggers{keys %all_triggers} = undef;
    grep { @triggers{@{$_}} = undef } values %standard_triggers;
    return keys %triggers;
}

my %additional_triggers;

# Used for determining who triggered something.
my %trigger_lookup;

sub add_triggers {
    my ($options, $type, $triggers) = @_;
    my @triggers = ref $triggers eq 'ARRAY' ? @{$triggers} : $triggers;
    my %existing;
    @existing{@{$additional_triggers{$type}}} = 1
        if defined($additional_triggers{$type});
    foreach my $trigger (@triggers) {
        if (exists($existing{$trigger})) {
            die "Trigger '$trigger' already in use!\n";
        };
    };
    my @new_triggers = (keys %existing, @triggers);
    $additional_triggers{$type} = \@new_triggers;
    @trigger_lookup{@triggers} = map { $options } (1..@triggers);
}

sub cheat_sheet_file_for {
    my $name = shift;
    $name =~ s/ /-/g;
    return "$name.json";
}

sub getAliases {
    my @files = File::Find::Rule->file()
                                ->name("*.json")
                                ->in(share('json'));
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

        if ($data->{triggers}) {
            my %default_options = (
                require_name => 1,
            );
            my $options = {
                file => $file,
            };
            if ($data->{triggers}->{options}) {
                my $trigger_options = delete $data->{triggers}->{options};
                my %new_options = (%{$trigger_options}, %{$options});
                $options = \%new_options;
            };
            while (my ($type, $triggers) = each $data->{triggers}) {
                my %options = (%default_options, %{$options});
                add_triggers(\%options, $type, $triggers);
            };
        };

        if ($data->{'aliases'}) {
            foreach my $alias (@{$data->{'aliases'}}) {
                my $lc_alias = lc $alias;
                if (defined $results{$lc_alias}
                    && $results{$lc_alias} ne $file) {
                    die "Cannot use an alias that is another cheat sheet's name ($lc_alias) in $file"
                        if -f "$cheat_dir/@{[cheat_sheet_file_for $lc_alias]}";
                    die "Name already in use '$lc_alias' in $file"
                        if defined($results{$lc_alias});
                }
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
    my $matched_trigger = $req->matched_trigger;
    my ($was_additional, $who) = who_triggered($remainder, $matched_trigger);
    open my $fh, $who or return;

    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json);
    unless ($was_additional || exists($all_triggers{$matched_trigger})) {
        my $template_type = ($data->{template_type});
        my @categories = ($template_type);
        push @categories, @{$data->{additional_categories}}
            if defined $data->{additional_categories};
        my $matched = 0;
        foreach my $category (@categories) {
            my %triggers;
            @triggers{@{$standard_triggers{$category}}} = undef;
            if (exists $triggers{$matched_trigger}) {
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
