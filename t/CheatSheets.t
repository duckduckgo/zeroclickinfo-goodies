#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use JSON::XS;

zci answer_type => "cheat_sheet";
zci is_cached   => 1;

sub build_answer {
    my ($filename) = @_;
    my $file = 'share/goodie/cheat_sheets/json/'.$filename;
    
    open my $fh, $file or return;
    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json);
    
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
    'windows cheat sheet' => test_zci(build_answer('microsoft-windows.json')),
    'blender shortcuts' => test_zci(build_answer('blender.json')),
    'regexp examples' => test_zci(build_answer('regex.json')),
    'git help' => test_zci(build_answer('git.json'))
);

done_testing;
