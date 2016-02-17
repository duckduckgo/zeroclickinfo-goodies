package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files

use JSON::XS;
use DDG::Goodie;
use DDP;
use File::Find::Rule;
use YAML::XS qw(LoadFile);

no warnings 'uninitialized';

zci answer_type => 'cheat_sheet';
zci is_cached   => 1;

my $trigger_data = LoadFile(share('triggers.yaml'));

# Instantiate triggers as defined in 'triggers.json', return a
# hash that allows category and/or cheat sheet look-up based on
# trigger.
sub generate_triggers {
    my $aliases = @_;

    # Initialize categories
    my %categories;
    my $category_map = $trigger_data->{template_map};
    my %spec_triggers = %{$trigger_data->{categories}};
    # Initialize custom triggers
    foreach (my ($id, $spec) = each ($trigger_data->{custom_triggers} || {})) {
        $category_map->{$id} = $spec->{additional_categories}
            if defined $spec->{additional_categories};
        $spec_triggers{$id} = $spec->{triggers}
            if defined $spec->{triggers};
    }

    while (my ($template_type, $categories) = each $category_map) {
        foreach my $category (@{$categories}) {
            $categories{$category}{$template_type} = 1;
        }
    }

    # Initialize triggers

    # This will contain the actual triggers, with the triggers as values and
    # the trigger positions as keys (e.g., 'startend' => ['foo'])
    my %triggers;
    # This will contain a lookup from triggers to categories and/or files.
    my %trigger_lookup;

    while (my ($name, $trigger_setsh) = each %spec_triggers) {
        my $ignore_phrases = $trigger_setsh->{ignore}
            if exists($trigger_setsh->{ignore});
        while (my ($trigger_type, $triggersh) = each $trigger_setsh) {
            next if $trigger_type eq 'ignore';
            foreach my $trigger (@{$triggersh}) {
                # Add trigger to global triggers.
                $triggers{$trigger_type}{$trigger} = 1;
                $trigger_lookup{ignore}{$trigger} = $ignore_phrases
                    if defined $ignore_phrases;
                my %new_triggers = map { $_ => 1}
                    (keys %{$trigger_lookup{$trigger}});
                if ($name !~ /cheat_sheet$/) {
                    %new_triggers = (%new_triggers, %{$categories{$name}});
                } else {
                    $new_triggers{$name} = 1;
                }
                $trigger_lookup{$trigger} = \%new_triggers;
            }
        }
    }
    while (my ($trigger_type, $triggers) = each %triggers) {
        triggers $trigger_type => (keys %{$triggers});
    }
    return %trigger_lookup;

}

# Initialize aliases.
sub get_aliases {
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

my $aliases = get_aliases();

my %trigger_lookup = generate_triggers($aliases);

handle remainder => sub {
    my $remainder = shift;

    my $trigger = join(' ', split /\s+/o, lc($req->matched_trigger));
    my $lookup = $trigger_lookup{$trigger};
    if (exists $trigger_lookup{ignore}{$trigger}) {
        foreach my $ignore (@{$trigger_lookup{ignore}{$trigger}}) {
            $remainder =~ s/\b$ignore\b//;
        }
        $remainder =~ s/^\s+//;
        $remainder =~ s/\s+$//;
    }

    my $file = $aliases->{join(' ', split /\s+/o, lc($remainder))} or return;
    open my $fh, $file or return;
    my $json = do { local $/; <$fh> };
    my $data = decode_json($json) or return;
    # Either the template type of the cheat sheet must support
    # the trigger category, or the lookup must explicitly allow
    # the current id.
    return unless $lookup->{$data->{template_type}} || $lookup->{$data->{id}};

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
