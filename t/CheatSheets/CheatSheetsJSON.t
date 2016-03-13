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
use List::Util qw(first none all any);
use YAML::XS qw(LoadFile);

my $json_dir = "share/goodie/cheat_sheets/json";

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
    my $json;

    ### File tests ###
    my $temp_pass = (my $content < io($path))? 1 : 0;
    push(@tests, {msg => 'could not read file', critical => 1, pass => $temp_pass});

    $temp_pass = (eval { $json = decode_json($content) })? 1 : 0;
    push(@tests, {msg => 'invalid JSON', critical => 1, pass => $temp_pass});
    goto PRINT_RESULTS unless $json; # No point continuing if we cannot read the JSON

    ### Headers tests ###
    $temp_pass = (my $cheat_id = $json->{id}) ? 1 : 0;
    push(@tests, {msg => 'No ID specified', critical => 1, pass => $temp_pass});;

    $temp_pass = ($json->{name})? 1 : 0;
    push(@tests, {msg => 'No name specified', critical => 1, pass => $temp_pass});

    $temp_pass = (!exists $json->{description} && !$json->{description})? 0 : 1;
    push(@tests, {msg => "No description specified", critical => 0, pass => $temp_pass});

    ### Template Type tests ###
    $temp_pass = (exists $json->{template_type} && $json->{template_type})? 1 : 0;
    push(@tests, {msg => "'template_type' not specified", critical => 1, pass => $temp_pass});
    my $template_type = $json->{template_type};
    $temp_pass = (exists $template_map->{$template_type});
    push(@tests, {msg => "Invalid template_type '$template_type'", critical => 1, pass => $temp_pass});

    my %categories;

    if ($cheat_id) {
        ### ID tests ###
        $temp_pass = id_to_file_name($cheat_id) eq $file_name;
        push(@tests, {msg => "Invalid file name ($file_name) for ID ($cheat_id)", critical => 1, pass => $temp_pass});

        $temp_pass = $cheat_id =~ /_cheat_sheet$/;
        push(@tests, {msg => "ID ($cheat_id) does not end with '_cheat_sheet'", critical => 1, pass => $temp_pass});

        ### Trigger tests ###
        if (my $custom = $triggers_yaml->{custom_triggers}->{$cheat_id}) {
            %categories = map { $_ => 1 } @{$custom->{additional_categories}};
            # Duplicate triggers
            foreach my $trigger (flat_triggers($custom)) {
                $temp_pass = $triggers{$trigger}++ ? 0 : 1;
                push(@tests, {msg => "Trigger '$trigger' already in use", critical => 1, pass => $temp_pass});
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
                push(@tests, {msg => "Uppercase detected in alias - aliases should be lowercase", critical => 1});
            }
            if (first { lc $_ eq $defaultName } @aliases) {
                push(@tests, {msg => "aliases contain the cheat sheet name ($defaultName)", critical => 1});
            }
            # Make sure aliases don't contain any category triggers.
            while (my ($category, $trigger_types) = each %{$triggers_yaml->{categories}}) {
                my $critical = $categories{$category};
                if (my ($alias, $trigger) = check_aliases_for_triggers(\@aliases, $trigger_types)) {
                    push(@tests, {msg => "Alias ($alias) contains a trigger ($trigger) defined in the '$category' category", critical => $critical});
                }
            }
            # Make sure aliases don't contain any custom triggers for the cheat sheet.
            if (my $custom = $triggers_yaml->{custom_triggers}{$cheat_id}) {
                if (my ($alias, $trigger) = check_aliases_for_triggers(\@aliases, $custom)) {
                    push(@tests, {msg => "Alias ($alias) contains a custom trigger ($trigger)", critical => 1});
                }
            }
        }
    }

    %categories = (%categories, map { $_ => 1 } @{$template_map->{$template_type}});

    ### Metadata tests ###
    my $has_meta = exists $json->{metadata};

    $temp_pass = $has_meta? 1 : 0;
    push(@tests, {msg => "'metadata' attribute was not specified (optional but suggested)", critical => 0, pass => $temp_pass, skip => 1});

    $temp_pass = exists $json->{metadata}{sourceName}? 1 : 0;
    push(@tests, {msg => "'sourceName' was not specified in 'metadata'", critical => 1, pass => $temp_pass, skip => 1});

    $temp_pass = exists $json->{metadata}{sourceUrl}? 1 : 0;
    push(@tests, {msg => "'sourceUrl' was not specified in 'metadata'", critical => 0, pass => $temp_pass, skip => 1});

    $temp_pass = (my $url = $json->{metadata}{sourceUrl})? 1 : 0;
    push(@tests, {msg => "'sourceUrl' was undefined", critical => 1, pass => $temp_pass, skip => 1});;

    ### Sections tests ###
    $temp_pass = (my $order = $json->{section_order})? 1 : 0;
    push(@tests, {msg => "'section_order' not specified", critical => 1, pass => $temp_pass});

    $temp_pass = (ref $order eq 'ARRAY')? 1 : 0;
    push(@tests, {msg => "'section_order' is not an array", critical => 1, pass => $temp_pass});

    $temp_pass = (my $sections = $json->{sections})? 1 : 0;
    push(@tests, {msg => 'No sections were specified', critical => 1, pass => $temp_pass});

    $temp_pass = (ref $sections eq 'HASH')? 1 : 0;
    push(@tests, {msg => "'sections' is not a hash", critical => 1, pass => $temp_pass});

    my %sections = %$sections;

    # Check for sections defined in section_order but not used
    if (my @unused = grep { not defined delete $sections{$_} } (@$order)) {
        my $unused = join ', ', map { "'$_'" } @unused;
        push(@tests, {msg => "The following sections were defined in 'section_order' but not used in 'sections': ($unused)", critical => 1, pass => 0});
    }

    # Check for sections used but not defined in section_order
    if (my $undefined_sections = join ', ', map { "'$_'" } (keys %sections)) {
        push(@tests, {msg => "The following sections were used in 'sections' but not defined in 'section_order:' ($undefined_sections)", critical => 1, pass => 0});
    }

    while (my ($section_name, $section_contents) = each $sections) {
        unless (ref $section_contents eq 'ARRAY') {
            push(@tests, {msg => "Value for section '$section_name' is not an array", critical => 1, pass => 0});
            next;
        }
        my $entry_count = 0;
        foreach my $entry (@$section_contents) {
            # Only show it when it fails, otherwise it clutters the output
            push(@tests, {msg => "No key specified for entry $entry_count in the '$section_name' section", critical => 1, pass => 0}) unless exists $entry->{key};

            #push(@tests, {msg => "'$section_name' entry: $entry_count has a val from $name", critical => 1, pass => 0}) unless exists $entry->{val};
            $entry_count++;

            # spacing in keys ([a]/[b])'
            if (my $val = $entry->{val}) {
                if ($val =~ /\(\[.+\]\/\[.+\]\)/g) {
                    push(@tests, {msg => "No spacing around keys in '$val' (use ([a] / [b]) rather than ([a]/[b]))", critical => 0, pass => 0});
                }
                push(@tests, {msg => "Trailing whitespace in value '$val'",  critical => 0, pass => 0}) if $val =~ /\s$/;
            }
            if (my $key = $entry->{key}) {
                if ($key =~ /\(\[.*\]\/\[.+\]\)/g) {
                    push(@tests, {msg => "No spacing around keys in '$key' (use ([a] / [b]) rather than ([a]/[b])", critical => 0, pass => 0});
                }
                push(@tests, {msg => "Trailing whitespace in key '$key'", critical => 0, pass => 0}) if $key =~ /\s$/;
            }
        }
    }

    PRINT_RESULTS:

    my $result = print_results($name, \@tests);

    subtest 'can_build' => sub {
        ok($result->{pass}, $result->{msg});
    };
}

sub print_results {
    my ($name, $tests) = @_;

    my $expected_max_length = 30;
    my @failures = grep { !$_->{pass} && !$_->{skip} } @$tests;
    # 'green' => pass; 'yellow' => some warnings; 'red' => any critical
    my $total_color = !@failures ? 'green' :
        ((any { $_->{critical} } @failures) ? 'red' : 'yellow');
    my %result = (pass => 1, msg => $name . ' is build safe');
    # We report the number of failures or a pass
    my $overall_msg = @failures ? @failures . ' FAILURE' . ($#failures ? 'S' : '') : 'PASS';
    # Attempt to keep the test reports aligned (mostly)
    my $dots = join '', map { '.' } (1..$expected_max_length - length $name);
    diag colored([$total_color], "Testing " . $name . $dots . ' ' . $overall_msg);
    for my $test (@failures) {
        my $temp_msg = $test->{msg};

        if ($test->{critical}) {
            $temp_msg = "FAIL: " . $temp_msg;
            %result = (pass => 0, msg => $temp_msg);
            diag colored(['red'], "\t -> " . $temp_msg);
        } else {
            $temp_msg = "WARN: " . $temp_msg;
            diag colored(['yellow'], "\t -> " . $temp_msg);
        }
    }

    return \%result;
}
done_testing;
