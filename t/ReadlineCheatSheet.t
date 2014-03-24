#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'readline_cheat';

# This goodie always returns one of two possible answers
my $emacs_answer = test_zci(
        qr/Moving.*History.*Changing.*Killing/s,
	    heading => 'Readline Cheat Sheet - Emacs Editing Mode',
		html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
);
my $vi_answer = test_zci(
        qr/Cutting.*Undo.*History.*Marks/s,
	    heading => 'Readline Cheat Sheet - Vi Editing Mode',
		html => qr#<div(.*<table.*<tr.*<td.*</table.*)+</div>$#s,
);

ddg_goodie_test(
	[ 'DDG::Goodie::ReadlineCheatSheet' ],
    'readline cheat sheet'             => $emacs_answer,
    'readline cheatsheet'              => $emacs_answer,
    'readline commands'                => $emacs_answer,
    'readline guide'                   => $emacs_answer,
    'readline help'                    => $emacs_answer,
    'readline quick reference'         => $emacs_answer,
    'readline reference'               => $emacs_answer,
    'read line cheat sheet'            => $emacs_answer,
    'read line cheatsheet'             => $emacs_answer,
    'read line commands'               => $emacs_answer,
    'read line guide'                  => $emacs_answer,
    'read line help'                   => $emacs_answer,
    'read line quick reference'        => $emacs_answer,
    'read line reference'              => $emacs_answer,
    'bash cheat sheet'                 => $emacs_answer,
    'bash cheatsheet'                  => $emacs_answer,
    'bash commands'                    => $emacs_answer,
    'bash guide'                       => $emacs_answer,
    'bash help'                        => $emacs_answer,
    'bash quick reference'             => $emacs_answer,
    'bash reference'                   => $emacs_answer,
    'bash cheat sheet vi editing mode' => $vi_answer,
    'readline help vim'                => $vi_answer,
    'read line reference vi'           => $vi_answer,
    'readline help emacs'              => $emacs_answer,
);

done_testing;
