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
use JSON;
use IO::All;
use List::Util qw(first);

my $json_dir = "share/goodie/cheat_sheets/json";
my $json;

sub file_name_to_id {
    my $file_name = shift;
    $file_name =~ s/\.json//;
    $file_name =~ s/-/_/g;
    return $file_name . "_cheat_sheet";
}

sub id_to_file_name {
    my $id = shift;
    $id =~ s/_cheat_sheet//;
    $id =~ s/_/-/g;
    return "$id.json";
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

    ### ID tests ###
    my $cheat_id = $json->{id};
    if ($cheat_id) {
        my $expected = file_name_to_id $file_name;
        $temp_pass = $cheat_id eq $expected;
        push(@tests, {msg => "bad id '$cheat_id', should be '$expected'", critical => 1, pass => $temp_pass});

        $expected = id_to_file_name $cheat_id;
        $temp_pass = $file_name eq $expected;
        push(@tests, {msg => "file name ($file_name) does not match ID, should be '$expected'", critical => 1, pass => $temp_pass});
    }

    ### Template Type tests ###
    $temp_pass = (exists $json->{template_type} && $json->{template_type})? 1 : 0;
    push(@tests, {msg => 'must specify a template type', critical => 1, pass => $temp_pass});

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

    ### Alias tests ###
    if (my $aliases = $json->{aliases}) {
        my @aliases = @{$aliases};
        if ("@aliases" =~ /[[:upper:]]/) {
            push(@tests, {msg => "uppercase detected in alias - aliases should be lowercase"});
        }
        if (first { lc $_ eq $defaultName } @aliases) {
            push(@tests, {msg => "aliases should not contain the cheat sheet name ($defaultName)"});
        }
    }


    ### Sections tests ###
    $temp_pass = (my $order = $json->{section_order})? 1 : 0;
    push(@tests, {msg => 'has section_order', critical => 1, pass => $temp_pass});

    $temp_pass = (ref $order eq 'ARRAY')? 1 : 0;
    push(@tests, {msg => 'section_order is an array of section names', critical => 1, pass => $temp_pass});

    # we're going to handle section case mismatches on frontend
    $_ = lc for @$order;

    $temp_pass = (my $sections = $json->{sections})? 1 : 0;
    push(@tests, {msg => 'has sections', critical => 1, pass => $temp_pass});

    $temp_pass = (ref $sections eq 'HASH')? 1 : 0;
    push(@tests, {msg => 'sections is a hash of section key/pairs', critical => 1, pass => $temp_pass});

    map {
        $sections->{lc$_} = $sections->{$_};
        delete $sections->{$_};
    } keys $sections;

    for my $section_name (@$order) {
        push(@tests, {msg => "Expected '$section_name' but not found", critical => 0, pass => 0})  unless $sections->{$section_name};
    }

    for my $section_name (keys %$sections) {
        push(@tests, {msg => "Section '$section_name' defined, but not listed in section_order", critical => 0, pass => 0}) unless grep(/\Q$section_name\E/, @$order);

        $temp_pass = (ref $sections->{$section_name} eq 'ARRAY')? 1 : 0;
        push(@tests, {msg => "'$section_name' is an array from $name",  critical => 1, pass => $temp_pass});

        my $entry_count = 0;
        for my $entry (@{$sections->{$section_name}}) {
            # Only show it when it fails, otherwise it clutters the output
            push(@tests, {msg => "'$section_name' entry: $entry_count has a key from $name", critical => 1, pass => 0}) unless exists $entry->{key};

            #push(@tests, {msg => "'$section_name' entry: $entry_count has a val from $name", critical => 1, pass => 0}) unless exists $entry->{val};
            $entry_count++;
        }
    }


    $sections = $json->{sections};

    for my $section_name (keys %{$sections}) {
        for my $entry (@{$sections->{$section_name}}){
            # spacing in keys ([a]/[b])'
            if ($entry->{val}) {
                if (($entry->{val} =~ /\(\[.*\]\/\[.+\]\)/g)) {
                    push(@tests, {msg => "keys ([a]/[b]) should have white spaces: $entry->{val} from  $name", critical => 0, pass => 0});
                }
               push(@tests, {msg => "No trailing white space in the value: $entry->{val} from: $name",  critical => 0, pass => 0}) if $entry->{val} =~ /\s"$/;
            }
            if ($entry->{key}) {
                if (($entry->{key} =~ /\(\[.*\]\/\[.+\]\)/g)) {
                    push(@tests, {msg => "keys ([a]/[b]) should have white spaces: $entry->{key} from  $name", critical => 0, pass => 0});
                }
                push(@tests, {msg => "No trailing white space in the value: $entry->{key} from: $name", critical => 0, pass => 0}) if $entry->{key} =~ /\s"$/;
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
                    return \%result;
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
