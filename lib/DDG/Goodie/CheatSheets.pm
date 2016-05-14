package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files

use JSON::MaybeXS;
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
    while (my ($id, $spec) = each %{$trigger_data->{custom_triggers} || {}}) {
        $category_map->{$id} = $spec->{additional_categories}
            if defined $spec->{additional_categories};
        $spec_triggers{$id} = $spec->{triggers}
            if defined $spec->{triggers};
    }

    while (my ($template_type, $categories) = each %$category_map) {
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
    # This will contain all the ignored phrases and their associated categories.
    my %ignore_phrases;

    while (my ($name, $trigger_setsh) = each %spec_triggers) {
        my $ignore_phrases = delete $trigger_setsh->{ignore};
        while (my ($trigger_type, $triggersh) = each %$trigger_setsh) {
            foreach my $trigger (@{$triggersh}) {
                # Add trigger to global triggers.
                $triggers{$trigger_type}{$trigger} = 1;
                # Handle ignored components - these will be stripped
                # from query and not be included in final trigger.
                if (defined $ignore_phrases) {
                    my %new_ignore_phrases = map { $_ => 1 }
                        (keys %{$ignore_phrases{$trigger} || {}},
                        @$ignore_phrases);
                    $ignore_phrases{$trigger} = \%new_ignore_phrases;
                }
                my %new_triggers = map { $_ => 1}
                    (keys %{$trigger_lookup{$trigger}});
                if ($name !~ /cheat_sheet$/) {
                    %new_triggers = (%new_triggers, %{$categories{$name} || {}});
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
    return (\%ignore_phrases, %trigger_lookup);
}

# Initialize aliases.
sub get_aliases {
    my @files = File::Find::Rule->file()
                                ->name("*.json")
                                ->in(share('json'));
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
                $results{lc $alias} = $file;
            }
        }
    }
    return \%results;
}

my $aliases = get_aliases();

my ($trigger_ignore, %trigger_lookup) = generate_triggers($aliases);

my %ignore_re = map {
    my $i = join '|', sort { length $b <=> length $a }
        keys %{$trigger_ignore->{$_}};
    $_ => qr/\b(?:$i)\b/;
} (keys %{$trigger_ignore});

handle remainder_lc => sub {
    my $remainder = join ' ', split /\s+/o, shift;

    my $trigger = join(' ', split /\s+/o, lc($req->matched_trigger));
    my $lookup = $trigger_lookup{$trigger};
    my $alias = exists $ignore_re{$trigger}
        ? ($remainder
            =~ s/$ignore_re{$trigger}//gr
            =~ s/^\s+//ro
            =~ s/\s+$//ro)
        : $remainder;

    my $file = $aliases->{$alias} or return;
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
