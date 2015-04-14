#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "cheat_sheet_cheat_sheet";
zci is_cached   => 1;

my @list = [{
    text => 'CronTab',
    url => 'https://duckduckgo.com/?q=crontab+help&ia=answer'
},
{
    text => 'GIMP',
    url => 'https://duckduckgo.com/?q=gimp+cheat+sheet&ia=answer'
},
{
    text => 'RegEx',
    url => 'https://duckduckgo.com/?q=regex+cheat+sheet&ia=answer'
},
{
    text => 'TMux',
    url => 'https://duckduckgo.com/?q=tmux+help&ia=answer'
},
{
    text => 'Emacs',
    url => 'https://duckduckgo.com/?q=emacs+cheat+sheet&ia=answer'
},
{
    text => 'Vim',
    url => 'https://duckduckgo.com/?q=vim+help&ia=answer'
},
{
    text => 'Color Codes',
    url => 'https://duckduckgo.com/?q=color+codes',
},
{
    text => 'Private Networks',
    url => 'https://duckduckgo.com/?q=private+networks&ia=answer'
},
{
    text => 'Public DNS',
    url => 'https://duckduckgo.com/?q=public+dns&ia=answer'
},
{
    text => 'DuckDuckGo Shortcuts',
    url => 'https://duckduckgo.com/?q=DuckDuckGo+shortcuts&ia=answer'
},
{
    text => 'Markdown Syntax',
    url => 'https://duckduckgo.com/?q=markdown+syntax+list&ia=answer'
}];

#Structured answer template data
my $templateData = {
        id => 'cheat_sheet_cheat_sheet',
        name => "CheatSheet CheatSheet",
        data => {
            list => @list,
        },
        templates => {
            group => 'list',
            options => {
                list_content => 'DDH.cheat_sheet_cheat_sheet.list_content'
            }
        }
};

ddg_goodie_test(
    [qw( DDG::Goodie::CheatSheetCheatSheet )],
    "duckduckgo cheat sheets" => test_zci(@list, structured_answer => $templateData),
    "ddg cheat sheets" => test_zci(@list, structured_answer => $templateData),
 
    # Do not trigger
    'cheat sheets' => undef,
    'ddh cheat' => undef,
    'duckduckgo sheet' => undef
);

done_testing;