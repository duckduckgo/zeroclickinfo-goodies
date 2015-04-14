package DDG::Goodie::CheatSheetCheatSheet;
# ABSTRACT: Shows the cheat sheets available on DuckDuckGo

use strict;
use warnings;
use DDG::Goodie;

zci answer_type => "cheat_sheet_cheat_sheet";
zci is_cached   => 1;

name "CheatSheetCheatSheet";
description "Cheat sheet for cheat sheets on DuckDuckGo";
primary_example_queries "duckduckgo cheat sheets", "ddg cheat sheets";
category "cheat_sheets";
topics "entertainment", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CheatSheetCheatSheet.pm";
attribution github => ["https://github.com/ngzhian", "ngzhian"],
            twitter => "ngzhian";

triggers start => "duckduckgo cheat sheets", "ddg cheat sheets";

# list of mappings from cheat sheet names to their url
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


handle remainder => sub {
    my $heading = 'Cheat sheets on DuckDuckGo';
    return @list,
        structured_answer => {
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
    }
};

1;
