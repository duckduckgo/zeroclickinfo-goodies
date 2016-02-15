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
    my $aliases = shift;
    my $triggers_json = share('triggers.json')->slurp();
    my $json_triggers = decode_json($triggers_json);
    # This will contain the actual triggers, with the triggers as values and
    # the trigger positions as keys (e.g., 'startend' => ['foo'])
    my %triggers;
    # This will contain a lookup from triggers to categories and/or files.
    my %trigger_lookup;

    while (my ($name, $trigger_setsh) = each $json_triggers) {
        if ($name =~ /cheat_sheet$/) {
            my $file = $name =~ s/_cheat_sheet//r;
            $file =~ s/_/ /g;
            $file = $aliases->{$file};
            die "Bad ID: '$name'" unless defined $file;
            $name = $file;
        }
        while (my ($trigger_type, $triggersh) = each $trigger_setsh) {
            while (my ($trigger, $enabled) = each $triggersh) {
                next unless $enabled;
                $triggers{$trigger_type}{$trigger} = 1;
                my %new_triggers = map { $_ => 1 }
                    (keys %{$trigger_lookup{$trigger}}, $name);
                $trigger_lookup{$trigger} = \%new_triggers;
            }
        }
    }
    while (my ($trigger_type, $triggers) = each %triggers) {
        triggers $trigger_type => (keys %{$triggers});
    }
    return %trigger_lookup;

}

# Retrieve the categories that can trigger the given cheat sheet.
sub supported_categories {
    my ($category_map, $data) = @_;
    my $template_type = $data->{template_type};
    my @additional_categories = @{$data->{categories}}
        if defined $data->{categories};
    my %categories = %{$category_map->{$template_type}};
    my @categories = (@additional_categories,
                      grep { $categories{$_} } (keys %categories));
    return \@categories;
}

# Initialize aliases and categories.
sub get_aliases_categories {
    my @files = File::Find::Rule->file()
                                ->name("*.json")
                                ->in(share('json'));
    my %results;

    # Initialize category maps
    my %categories;
    my $categories_json = share('categories.json')->slurp();
    my $category_map = decode_json($categories_json);

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

        # Add supported categories for the given cheat sheet
        $categories{$file} = supported_categories($category_map, $data);

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
    return (\%results, \%categories);
}

my ($aliases, $categories) = get_aliases_categories();

my %trigger_lookup = generate_triggers($aliases);

# Parse the JSON data contained within $file.
sub read_cheat_json {
    my $file = shift;
    open my $fh, $file or return;
    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json);
    return $data;
}

# Attempt to retrieve the JSON data based on the used trigger.
sub get_cheat_json {
    my ($remainder, $req) = @_;
    my $trigger = (lc $req->matched_trigger) =~ s/(\t|\s{2,})/ /gr;
    my $lookup = $trigger_lookup{$trigger};
    my $file = $aliases->{join(' ', split /\s+/o, lc($remainder))} or return;
    my $data = read_cheat_json($file) or return;
    return $data if defined $lookup->{$file};
    my @allowed_categories = @{$categories->{$file}};
    foreach my $category (@allowed_categories) {
        return $data if defined $lookup->{$category};
    }
}

handle remainder => sub {
    my $remainder = shift;

    my $data = get_cheat_json($remainder, $req) or return;

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
