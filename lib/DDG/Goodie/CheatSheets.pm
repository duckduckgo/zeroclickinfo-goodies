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

# Instantiate triggers as defined in 'triggers.json', return a
# hash that allows category and/or cheat sheet look-up based on
# trigger.
sub generate_triggers {
    my ($aliases, $categories) = @_;
    my $triggers_json = share('triggers.json')->slurp();
    my $json_triggers = decode_json($triggers_json);
    # This will contain the actual triggers, with the triggers as values and
    # the trigger positions as keys (e.g., 'startend' => ['foo'])
    my %triggers;
    # This will contain a lookup from triggers to categories and/or files.
    my %trigger_lookup;

    while (my ($name, $trigger_setsh) = each $json_triggers) {
        my $is_standard = 1;
        if ($name =~ /cheat_sheet$/) {
            my $file = $name =~ s/_cheat_sheet//r;
            $file =~ s/_/ /g;
            $file = $aliases->{$file};
            die "Bad ID: '$name'" unless defined $file;
            $name = $file;
            $is_standard = 0;
        }
        while (my ($trigger_type, $triggersh) = each $trigger_setsh) {
            while (my ($trigger, $enabled) = each $triggersh) {
                next unless $enabled;
                # Add trigger to global triggers.
                $triggers{$trigger_type}{$trigger} = 1;
                my %new_triggers = map { $_ => 1}
                    (keys %{$trigger_lookup{$trigger}});
                if ($is_standard) {
                    %new_triggers = (%new_triggers, %{$categories->{$name}});
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

sub get_categories {
    my %categories;
    my $categories_json = share('categories.json')->slurp();
    my $category_map = decode_json($categories_json);

    while (my ($template_type, $categories) = each $category_map) {
        while (my ($category, $enabled) = each $categories) {
            $categories{$category}{$template_type} = 1 if $enabled;
        }
    }
    return \%categories;
}

# Initialize aliases and categories.
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

my $categories = get_categories();

my %trigger_lookup = generate_triggers($aliases, $categories);

handle remainder => sub {
    my $remainder = shift;

    my $trigger = join(' ', split /\s+/o, lc($req->matched_trigger));
    my $lookup = $trigger_lookup{$trigger};
    my $file = $aliases->{join(' ', split /\s+/o, lc($remainder))} or return;
    open my $fh, $file or return;
    my $json = do { local $/; <$fh> };
    my $data = decode_json($json) or return;
    # Either the template type of the cheat sheet must support
    # the trigger category, or the lookup must explicitly allow
    # the current file.
    return unless $lookup->{$data->{template_type}} || $lookup->{$file};

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
