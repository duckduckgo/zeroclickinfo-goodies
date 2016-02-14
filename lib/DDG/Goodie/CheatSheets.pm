package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files

use JSON::XS;
use DDG::Goodie;
use DDP;
use File::Find::Rule;
use List::Util 'first';

no warnings 'uninitialized';

zci answer_type => 'cheat_sheet';
zci is_cached   => 1;

# These are aliases for cheat sheets specified in the individual json files
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
                $results{lc($alias)} = $file;
            }
        }
    }
    return \%results;
}

# This sets our triggers and returns a lookup to filter in remainder
sub generate_triggers{
    my ($trigger_file) = File::Find::Rule->file()
                                ->name('triggers.json')
                                ->in(share());

    open my $fh, $trigger_file or die "Error opening file $trigger_file: $!";
    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json); # we expect this to die if the file can't be decoded

    my (%cs_triggers, %trigger_lookup);
    while(my ($id, $x) = each %$data){
        # The cheat_sheets ID is for all cheat sheets and has a slight different structure
        if($id eq 'cheat_sheets'){
            while(my ($group, $trigger_types) = each %$x){
                my $all = $group eq 'ALL' ? $group : 0;
                while(my ($tt, $triggers) = each %$trigger_types){
                    while(my ($trigger, $on) = each %$triggers){
                        next unless $on;
                        # the lookup is for filtering in remainder
                        # the first are for *all* cheat sheets and
                        # the second for group-based filtering
                        if($all){
                            $trigger_lookup{$trigger} = $all;
                        }
                        else{
                            push @{$trigger_lookup{$trigger}}, $group;
                        }
                        # these are the triggers for the IA
                        push @{$cs_triggers{$tt}}, $trigger;
                    }
                }
            }
        }
        # custom triggers
        else{
            while(my ($tt, $triggers) = each %$x){
                while(my ($trigger, $on) = each %$triggers){
                    next unless $on;
                    # here a custom trigger can only refer to a specific ID
                    $trigger_lookup{$trigger} = $id;
                    # these are the triggers for the IA
                    push @{$cs_triggers{$tt}}, $trigger;
                }
            }
        }
    }

    while(my ($trigger_type, $triggers) = each %cs_triggers){
        triggers $trigger_type => @$triggers
    }

    return \%trigger_lookup;
}

my %aliases = %{get_aliases()};
my %trigger_lookup = %{generate_triggers()};

handle remainder => sub {
    # If needed we could jump through a few more hoops to check
    # terms against file names.
    open my $fh, $aliases{join(' ', split /\s+/o, lc($_))} or return;

    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json);

    # the matched trigger will be in the exact way the user specified, so let's normalize
    my $matched_trigger = join(' ', split /\s+/o, lc($req->matched_trigger));
    my $allowed = $trigger_lookup{$matched_trigger};
    # An array means it's a trigger applicable to template groups
    if(ref $allowed eq 'ARRAY'){
        my $tt = $data->{template_type};
        return unless first {$_ eq $tt} @$allowed;
    }
    else{
        # These apply to all cheat sheets or are custom for a single cheat sheet
        return unless ($allowed eq 'ALL') || ($allowed eq $data->{id});
    }

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
