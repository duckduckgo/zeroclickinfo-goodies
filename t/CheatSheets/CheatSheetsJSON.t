#!/usr/bin/env perl
#
# Cheat sheet tester created by David Farrell (https://github.com/dnmfarrell)
# from http://perltricks.com/article/190/2015/8/28/Check-your-DuckDuckGo-cheatsheets-with-Perl
#
use strict;
use warnings;
use open ':std', ':encoding(utf8)';
use Test::More;
use Term::ANSIColor;
use JSON::MaybeXS;
use IO::All;
use List::Util qw(first none);
use YAML::XS qw(LoadFile);

my $json_dir = "share/goodie/cheat_sheets/json";
my $json;

my $triggers_yaml = LoadFile('share/goodie/cheat_sheets/triggers.yaml');

my %triggers;

my $template_map = $triggers_yaml->{template_map};

sub flat_triggers {
    my $data = shift;
    if (my $triggers = $data->{triggers}) {
        return map { @$_ } values $triggers;
    }
    return ();
}

sub id_to_file_name {
    my $id = shift;
    return unless $id =~ s/_cheat_sheet//;
    $id =~ s/_/-/g;
    return $id . '.json';
}

sub check_aliases_for_triggers {
    my ($aliases, $trigger_types) = @_;
    my @aliases = @$aliases;
    while (my ($trigger_type, $triggers) = each %{$trigger_types}) {
        my @triggers = @$triggers;
        foreach my $alias (@aliases) {
            my $trigger;
            if (
                ($trigger_type =~ /^start/
                    && ($trigger = first { $alias =~ /^$_/ } @triggers))
            ||  ($trigger_type =~ /end$/
                    && ($trigger = first { $alias =~ /$_$/ } @triggers))
            ) {
                return ($alias, $trigger);
            }
        }
    }
    return;
}

# Iterate over all Cheat Sheet JSON files...
foreach my $path (glob("$json_dir/*.json")){
    next if $ARGV[0] && $path ne  "$json_dir/$ARGV[0].json";

    my ($file_name) = $path =~ /$json_dir\/(.+)/;
    my ($name) = $path =~ /.+\/(.+)\.json$/;
    my $defaultName = $name =~ s/-/ /gr;
    my @tests;

    ### File tests ###
    my $temp_pass = (my $content < io($path))? 1 : 0;
    push(@tests, {msg => 'file content can be read', critical => 1, pass => $temp_pass});

    $temp_pass = ($json = decode_json($content))? 1 : 0;
    push(@tests, {msg => 'content is valid JSON', critical => 1, pass => $temp_pass});

    ### Headers tests ###
    $temp_pass = (exists $json->{id} && $json->{id})? 1 : 0;
    push(@tests, {msg => 'has id', critical => 1, pass => $temp_pass});;

    $temp_pass = (exists $json->{name} && $json->{name})? 1 : 0;
    push(@tests, {msg => 'has name', critical => 1, pass => $temp_pass});

    $temp_pass = (!exists $json->{description} && !$json->{description})? 0 : 1;
    push(@tests, {msg => "has description (optional but suggested)", critical => 0, pass => $temp_pass});

    ### Template Type tests ###
    $temp_pass = (exists $json->{template_type} && $json->{template_type})? 1 : 0;
    push(@tests, {msg => 'must specify a template type', critical => 1, pass => $temp_pass});
    my $template_type = $json->{template_type};
    $temp_pass = (exists $template_map->{$template_type});
    push(@tests, {msg => "Invalid template_type '$template_type'", critical => 1, pass => $temp_pass});

    my %categories;

    if (my $cheat_id = $json->{id}) {
        ### ID tests ###
        $temp_pass = id_to_file_name($cheat_id) eq $file_name;
        push(@tests, {msg => "Invalid file name ($file_name) for ID ($cheat_id)", critical => 1, pass => $temp_pass});

        ### Trigger tests ###
        if (my $custom = $triggers_yaml->{custom_triggers}->{$cheat_id}) {
            %categories = map { $_ => 1 } @{$custom->{additional_categories}};
            # Duplicate triggers
            foreach my $trigger (flat_triggers($custom)) {
                $temp_pass = $triggers{$trigger}++ ? 0 : 1;
                push(@tests, {msg => "trigger '$trigger' already in use", critical => 1, pass => $temp_pass});
            }
            # Re-adding category
            foreach my $category (keys %categories) {
                $temp_pass = none { $_ eq $category } @{$template_map->{$template_type}};
                push(@tests, {msg => "Category '$category' already assigned", critical => 1, pass => $temp_pass});
            }
        }

        map { $categories{$_} = 1 } @{$template_map->{$template_type}};

        ### Alias tests ###
        if (my $aliases = $json->{aliases}) {
            my @aliases = @{$aliases};
            if ("@aliases" =~ /[[:upper:]]/) {
                push(@tests, {msg => "uppercase detected in alias - aliases should be lowercase", critical => 1});
            }
            if (first { lc $_ eq $defaultName } @aliases) {
                push(@tests, {msg => "aliases should not contain the cheat sheet name ($defaultName)", critical => 1});
            }
            # Make sure aliases don't contain any category triggers.
            while (my ($category, $trigger_types) = each %{$triggers_yaml->{categories}}) {
                my $critical = $categories{$category};
                if (my ($alias, $trigger) = check_aliases_for_triggers(\@aliases, $trigger_types)) {
                    push(@tests, {msg => "alias ($alias) contains a trigger ($trigger) defined in the '$category' category", critical => $critical});
                }
            }
            # Make sure aliases don't contain any custom triggers for the cheat sheet.
            if (my $custom = $triggers_yaml->{custom_triggers}{$cheat_id}) {
                if (my ($alias, $trigger) = check_aliases_for_triggers(\@aliases, $custom)) {
                    push(@tests, {msg => "alias ($alias) contains a custom trigger ($trigger)", critical => 1});
                }
            }
        }
    }

    %categories = (%categories, map { $_ => 1 } @{$template_map->{$template_type}});

    ### Metadata tests ###
    my $has_meta = exists $json->{metadata};

    $temp_pass = $has_meta? 1 : 0;
    push(@tests, {msg => 'has metadata (optional but suggested)', critical => 0, pass => $temp_pass, skip => 1});

    $temp_pass = exists $json->{metadata}{sourceName}? 1 : 0;
    push(@tests, {msg => "has metadata sourceName $name", critical => 1, pass => $temp_pass, skip => 1});

    $temp_pass = exists $json->{metadata}{sourceUrl}? 1 : 0;
    push(@tests, {msg => "has metadata sourceUrl $name", critical => 0, pass => $temp_pass, skip => 1});

    $temp_pass = (my $url = $json->{metadata}{sourceUrl})? 1 : 0;
    push(@tests, {msg => "sourceUrl is not undef $name", critical => 1, pass => $temp_pass, skip => 1});;

    ### Sections tests ###
    $temp_pass = (my $order = $json->{section_order})? 1 : 0;
    push(@tests, {msg => 'has section_order', critical => 1, pass => $temp_pass});

    $temp_pass = (ref $order eq 'ARRAY')? 1 : 0;
    push(@tests, {msg => 'section_order is an array of section names', critical => 1, pass => $temp_pass});

    $temp_pass = (my $sections = $json->{sections})? 1 : 0;
    push(@tests, {msg => 'has sections', critical => 1, pass => $temp_pass});

    $temp_pass = (ref $sections eq 'HASH')? 1 : 0;
    push(@tests, {msg => 'sections is a hash of section key/pairs', critical => 1, pass => $temp_pass});

    my %sections = %$sections;

    # Check for sections defined in section_order but not used
    if (my @unused = grep { not defined delete $sections{$_} } (@$order)) {
        my $unused = join ', ', map { "'$_'" } @unused;
        push(@tests, {msg => "The following sections were defined in section_order but not used: ($unused)", critical => 1, pass => 0});
    }

    # Check for sections used but not defined in section_order
    if (my $undefined_sections = join ', ', map { "'$_'" } (keys %sections)) {
        push(@tests, {msg => "The following sections were used but not defined in section_order: ($undefined_sections)", critical => 1, pass => 0});
    }

    while (my ($section_name, $section_contents) = each $sections) {
        unless (ref $section_contents eq 'ARRAY') {
            push(@tests, {msg => "Value for section '$section_name' must be an array", critical => 1, pass => 0});
            next;
        }
        my $entry_count = 0;
        foreach my $entry (@$section_contents) {
            # Only show it when it fails, otherwise it clutters the output
            push(@tests, {msg => "'$section_name' entry: $entry_count has a key from $name", critical => 1, pass => 0}) unless exists $entry->{key};

            #push(@tests, {msg => "'$section_name' entry: $entry_count has a val from $name", critical => 1, pass => 0}) unless exists $entry->{val};
            $entry_count++;

            # spacing in keys ([a]/[b])'
            if (my $val = $entry->{val}) {
                if ($val =~ /\(\[.*\]\/\[.+\]\)/g) {
                    push(@tests, {msg => "keys ([a]/[b]) should have white spaces: $val from  $name", critical => 0, pass => 0});
                }
                push(@tests, {msg => "No trailing white space in the value: $val from: $name",  critical => 0, pass => 0}) if $val =~ /\s"$/;
            }
            if (my $key = $entry->{key}) {
                if ($key =~ /\(\[.*\]\/\[.+\]\)/g) {
                    push(@tests, {msg => "keys ([a]/[b]) should have white spaces: $key from  $name", critical => 0, pass => 0});
                }
                push(@tests, {msg => "No trailing white space in the value: $key from: $name", critical => 0, pass => 0}) if $key =~ /\s"$/;
            }
        }
    }

    my $result = print_results($name, \@tests);

    subtest 'can_build' => sub {
        ok($result->{pass}, $result->{msg});
    };
}

sub print_results {
    my ($name, $tests) = @_;

    my $tot_pass = 0;
    my $tot_done = 0;
    my $ok = 1;
    my %result = (pass => 1, msg => $name . ' is build safe');
    for my $test (@{$tests}) {
        my $temp_msg = $test->{msg};
        my $temp_color = "reset";

        if (!$test->{skip}) {
            $tot_done++;

            if (!$test->{pass}) {
                if ($ok) {
                    $ok = 0;
                }

                if ($test->{critical}) {
                    diag colored(["red"], "Testing " . $name . "...........NOT OK");
                    $temp_color = "red";
                    $temp_msg = "FAIL: " . $temp_msg;
                    %result = (pass => 0, msg => $temp_msg);
                    diag colored([$temp_color], "\t -> " . $temp_msg);
                } else {
                    diag colored(["green"], "Testing " . $name . "...........OK");
                    $temp_color = "yellow";
                    $temp_msg = "WARN: " . $temp_msg;
                    diag colored([$temp_color], "\t -> " . $temp_msg);
                }
            } else {
                $tot_pass++;
            }
        }
    }

    if ($ok) {
        diag colored(["green"], "Testing " . $name . "..........OK");
    }

    return \%result;
}
done_testing;
