#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use JSON::XS;
use File::Find::Rule;

zci answer_type => "cheat_sheet";
zci is_cached   => 1;

sub getTests {
    my @files = File::Find::Rule->file()
                                ->name("*.json")
                                ->in('share/goodie/cheat_sheets/json/');
    my %tests;
    my %aliases;
    my $cheat_dir = File::Basename::dirname($files[0]);

    foreach my $file (@files) {
        open my $fh, $file or return;
        my $json = do { local $/;  <$fh> };
        my $data = decode_json($json);

        my $name = File::Basename::fileparse($file);
        my $defaultName = $name =~ s/-/ /gr;
        $defaultName =~ s/.json//;

        $aliases{$defaultName} = $file;

        $tests{$defaultName." cheat sheet"} = test_zci(build_answer($data));

        if ($data->{'aliases'}) {
            foreach my $alias (@{$data->{'aliases'}}) {
                my $lc_alias = lc $alias;
                if (defined $aliases{$lc_alias}
                    && $aliases{$lc_alias} ne $file) {
                    my $other_file = $aliases{$lc_alias} =~ s/$cheat_dir\///r;
                    die "$name and $other_file both using alias '$lc_alias'";
                }
                $aliases{$lc_alias} = $file;
                $tests{$alias." cheat sheet"} = test_zci(build_answer($data));
            }
        }
    }
    return \%tests;
}

sub build_answer {
    my ($data) = @_;

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
}

ddg_goodie_test(
    [qw( DDG::Goodie::CheatSheets )],
    %{getTests()}
);

done_testing;
