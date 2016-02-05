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

sub generate_triggers {
    my $triggers_json = share('triggers.json')->slurp();
    my $triggers = decode_json($triggers_json);
    my %cat_triggers = %{$triggers->{standard}};
    %cat_triggers = make_category_triggers(%cat_triggers);
    delete $triggers->{standard};
    my %custom_triggers = %{$triggers};
    %custom_triggers = make_identity_triggers(%custom_triggers);
    my %triggers;
    while (my ($trigger_type, $triggers) = each %cat_triggers) {
        my @triggers = $triggers{$trigger_type}
            if defined $triggers{$trigger_type};
        @triggers = (@triggers, @{$triggers});
        $triggers{$trigger_type} = \@triggers;
    }
    while (my ($trigger_type, $triggers) = each %custom_triggers) {
        my @triggers = $triggers{$trigger_type}
            if defined $triggers{$trigger_type};
        @triggers = (@triggers, @{$triggers});
        $triggers{$trigger_type} = \@triggers;
    }
    return %triggers;
}

my %identity_triggers;

sub make_triggers {
    my $runner = shift;
    return sub {
        my %spec_triggers = @_;
        my %triggers;
        while (my ($id, $trigger_hash) = each %spec_triggers) {
            my @track_triggers;
            while (my ($trigger_type, $add_triggers) = each $trigger_hash) {
                my @triggers = @{$triggers{$trigger_type}} if exists($triggers{$trigger_type});
                @triggers = (@triggers, @{$add_triggers});
                @track_triggers = (@track_triggers, @{$add_triggers});
                $triggers{$trigger_type} = \@triggers;
            }
            $runner->($id, @track_triggers);
        }
        return %triggers;
    };
}
sub make_identity_triggers {
    my $add_identities = sub {
        my ($id, @identity_triggers) = @_;
        map { $identity_triggers{$_} = $id } @identity_triggers;
    };
    return make_triggers($add_identities)->(@_);
}

my %category_triggers;

sub make_category_triggers {
    my $add_categories = sub {
        my ($category, @category_triggers) = @_;
        my %new_triggers = map { $_ => 1 } @category_triggers;
        $category_triggers{$category} = \%new_triggers;
    };
    return make_triggers($add_categories)->(@_);
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

my %cheat_triggers = generate_triggers();

triggers any      => @{$cheat_triggers{any}}
    if $cheat_triggers{any};
triggers end      => @{$cheat_triggers{end}}
    if $cheat_triggers{end};
triggers start    => @{$cheat_triggers{start}}
    if $cheat_triggers{start};
triggers startend => @{$cheat_triggers{startend}}
    if $cheat_triggers{startend};

sub cheat_sheet_name_from_id {
    my $id = shift;
    $id =~ s/_cheat_sheet//;
    $id =~ s/_/ /g;
    return $id;
}

# (was custom trigger?, trigger file)
sub who_triggered {
    my ($remainder, $trigger) = @_;
    my $who = $identity_triggers{$trigger}
        if exists $identity_triggers{$trigger};
    return (1, $aliases->{cheat_sheet_name_from_id $who})
        if defined $who;
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


sub acceptable_triggers_for {
    my $data = shift;
    my @categories = categories_for $data;
    my %triggers;
    foreach my $category (@categories) {
        my %cat_triggers = %{$category_triggers{$category}};
        %triggers = (%triggers, %cat_triggers);
    }
    return %triggers;
}

sub has_trigger {
    my ($data, $matched_trigger) = @_;
    my %acceptable_triggers = acceptable_triggers_for $data;
    return $acceptable_triggers{$matched_trigger};
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
    return unless $was_custom || has_trigger($data, $matched_trigger);# $acceptable_triggers{$matched_trigger};

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
