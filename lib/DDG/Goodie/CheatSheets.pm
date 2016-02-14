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

# Generate all the possible triggers as specified in the 'triggers.json' file.
sub generate_triggers {
    my $aliases = shift;
    my $triggers_json = share('triggers.json')->slurp();
    my $json_triggers = decode_json($triggers_json);
    my $standard_triggers = $json_triggers->{standard};
    delete $json_triggers->{standard};
    my %all_triggers = (%{$standard_triggers}, %{$json_triggers});
    my $normalized_triggers = normalize_triggers(\%all_triggers);
    my ($trigger_lookup, $triggers) = make_all_triggers($aliases, $normalized_triggers);
    return ($trigger_lookup, $triggers);
}

# Normalize triggers to a default form - i.e, any triggers without options
# will be assigned the defaults.
sub normalize_triggers {
    my $triggers = shift;
    my $normalized_triggers = {};
    my $defaults = {
        require_name => 1,
    };
    while (my ($name, $trigger_setsh) = each $triggers) {
        my $normalized_sets = {};
        while (my ($trigger_type, $triggersh) = each $trigger_setsh) {
            my $normalized_set = {};
            while (my ($trigger, $opts) = each $triggersh) {
                if ($opts == 0 || ref $opts eq 'HASH') {
                    $normalized_set->{$trigger} = $opts;
                    next;
                }
                $normalized_set->{$trigger} = $defaults;
            }
            $normalized_sets->{$trigger_type} = $normalized_set;
        }
        $normalized_triggers->{$name} = $normalized_sets;
    }
    return $normalized_triggers;
}

sub make_all_triggers {
    my ($aliases, $spec_triggers) = @_;
    # This will contain the actual triggers, with the triggers as values and
    # the trigger positions as keys (e.g., 'startend' => ['foo'])
    my $triggers = {};
    # This will contain a lookup from triggers to categories and/or files.
    my $trigger_lookup = {};
    while (my ($name, $trigger_setsh) = each $spec_triggers) {
        if ($name =~ /cheat_sheet$/) {
            my $file = $aliases->{cheat_sheet_name_from_id($name)};
            warn "Bad ID: '$name'" unless defined $file;
            $name = $file;
        }
        while (my ($trigger_type, $triggersh) = each $trigger_setsh) {
            my @triggers_for_type;
            while (my ($trigger, $opts) = each $triggersh) {
                next if $opts == 0;
                my $require_name = $opts->{require_name};
                push @triggers_for_type, $trigger;
                unless ($require_name) {
                    warn "Overriding trigger '$trigger' with custom for '$name'"
                        if exists $trigger_lookup->{$trigger};
                    $trigger_lookup->{$trigger} = $name;
                    next;
                }
                my %new_triggers = map { $_ => 1 } (keys %{$trigger_lookup->{$trigger}});
                $new_triggers{$name} = 1;
                $trigger_lookup->{$trigger} = \%new_triggers;
            }
            my @new_triggers_for_type = @{$triggers->{$trigger_type}}
                if defined $triggers->{$trigger_type};
            @new_triggers_for_type = (@new_triggers_for_type,
                                      @triggers_for_type);
            $triggers->{$trigger_type} = \@new_triggers_for_type;
        }
    }
    return ($trigger_lookup, $triggers);

}

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

my ($trigger_lookup, $cheat_triggers) = generate_triggers($aliases);

triggers any      => @{$cheat_triggers->{any}}
    if $cheat_triggers->{any};
triggers end      => @{$cheat_triggers->{end}}
    if $cheat_triggers->{end};
triggers start    => @{$cheat_triggers->{start}}
    if $cheat_triggers->{start};
triggers startend => @{$cheat_triggers->{startend}}
    if $cheat_triggers->{startend};

sub cheat_sheet_name_from_id {
    my $id = shift;
    $id =~ s/_cheat_sheet//;
    $id =~ s/_/ /g;
    return $id;
}

# (was custom trigger?, trigger file)
sub who_triggered {
    my ($remainder, $trigger) = @_;
    my $lookup = $trigger_lookup->{$trigger};
    unless (ref $lookup eq 'HASH') {
        return (1, $lookup);
    }
    my $file = $aliases->{join(' ', split /\s+/o, lc($remainder))};
    return (0, $file);
}

sub categories_for {
    my $data = shift;
    my $template_type = ($data->{template_type});
    my @categories = ('standard', $template_type);
    @categories = (@categories, @{$data->{additional_categories}})
        if defined $data->{additional_categories};
    return @categories;
}



handle remainder => sub {
    my $remainder = shift;
    # If needed we could jump through a few more hoops to check
    # terms against file names.
    my $matched_trigger = $req->matched_trigger;
    my ($was_custom, $who) = who_triggered($remainder, $matched_trigger);
    open my $fh, $who or return;

    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json);
    return unless $was_custom;

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
