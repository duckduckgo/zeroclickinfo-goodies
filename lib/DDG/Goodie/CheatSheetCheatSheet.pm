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

# maps cheat sheet names to their url
my %mapping = (
    'CronTab' => 'https://duckduckgo.com/?q=crontab+help&ia=answer',
    'GIMP' => 'https://duckduckgo.com/?q=gimp+cheat+sheet&ia=answer',
    'RegEx' => 'https://duckduckgo.com/?q=regex&ia=answer',
    'TMux' => 'https://duckduckgo.com/?q=tmux+help&ia=answer',
    'Emacs' => 'https://duckduckgo.com/?q=emacs+cheat+sheet&ia=answer',
    'Vim' => 'https://duckduckgo.com/?q=vim+help&ia=answer',
    'Color Codes' => 'https://duckduckgo.com/?q=color+codes',
    'Private Networks' => 'https://duckduckgo.com/?q=private+networks&ia=answer',
    'Public DNS' => 'https://duckduckgo.com/?q=public+dns&ia=answer',
    'DuckDuckGo Shortcuts' => 'https://duckduckgo.com/?q=DuckDuckGo+shortcuts&ia=answer',
    'Markdown Syntax' => 'https://duckduckgo.com/?q=markdown+syntax+list&ia=answer'
);


handle remainder => sub {
    my $html_output = '';
    my $text_output = '';
    my $heading = 'Cheat sheets on DuckDuckGo';
    foreach my $cheatsheet (sort keys %mapping) {
        $html_output .= '<p><a href="' . $mapping{$cheatsheet} . '">' . $cheatsheet . '</a></p>';
        $text_output .= $cheatsheet . ' - ' . $mapping{$cheatsheet} . '\n';
        
    }

    return answer => $text_output, html => $html_output, heading => $heading;
};

1;
