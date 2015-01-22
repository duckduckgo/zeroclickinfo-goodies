#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "emacs_cheat_sheet";
zci is_cached   => 1;

my $test_zci = test_zci(
'Lingo:
C: control key (CTRL)
M: meta key (ALT or ESC)
Quick Answers:
C-x C-f: find file
C-x C-s: save file
C-x C-c: exit emacs
Cursor Motion
Operation
Move
Move
Delete
Delete
Forward
Backward
Forward
Backward
Characters
C-f
C-b
C-d
DEL
Words
M-f
M-b
M-d
M-DEL
Lines
C-n
C-p
C-k
C-SPC C-a C-w
Sentences
M-e
M-a
M-k
C-x DEL
Expressions
C-M-f
C-M-b
C-M-k
C-M-DEL
Paragraphs
M-}
M-{
None
None
End/Start of Line
C-e
C-a
None
None
End/Start of Buffer
M-&gt;
M-&lt;
None
None 
Scrolling and Windows
C-v
Page Down
M-v
Page Up
C-M-v
Page Down other window
C-x 1
Make current window only window
C-x 2
Split window vertically
C-x 3
Split window horizontally
C-x ^
Grow window vertically
C-x o
Switch to next window
C-x 0
Close current window
Cutting and Pasting
C-SPC
Set mark
C-w
Cut (after setting mark and moving to end point)
M-w
Copy (after setting mark and moving to end point)
C-y
Yank (paste) most recently killed (cut or copied)
M-y
Yank next most recently killed
Files and Buffers

C-x C-f
Find file (or create if not existing)
C-x C-s
Save file
C-x C-w
Write file
C-x s
Save modified buffers
C-x b
Select buffer
C-x C-b
List buffers
C-x k
Kill buffer
Command-Related Stuff
ESC ESC ESC
Leave current location
C-u #
Prefix numeric argument # to next command
C-g
Stop running command, or cancel partially entered command
Searching and Replacing
C-s
Incremental search forward
C-r
Incremental search backward
C-M-s
Regexp search forward
C-M-r
Regexp search backward
M-x replace-string RET
String replace from here to end of buffer
M-x query-replace RET
String replace from here to end of buffer, querying for each occurrence
M-x grep RET
Prompts for a grep command, shows hits in a buffer
C-x `
Visit next grep hit
Help
C-h k
Show command documentation
C-h a
"Command apropos"
C-h c
Show command name on message line
C-h f
Describe function
C-h i
Info browser
Misc
C-_ or C-x u
Undo/redo
C-q
Quoted insert
C-z
Suspend/iconify emacs (type "%emacs" to return)
C-x C-c
Exit emacs',
heading => 'Emacs Cheat Sheet',
html => '<div id="sheet-container">
    <div class="sheet-column">
        <b>Lingo:</b>
        <p>C: control key (CTRL)<br>
        M: meta key (ALT or ESC)<br></p>
    </div>
    <div class="sheet-column">
        <b>Quick Answers:</b>
        <p><code>C-x C-f</code>: find file<br>
        <code>C-x C-s</code>: save file<br>
        <code>C-x C-c</code>: exit emacs<br></p>
    </div>
    
    <b>Cursor Motion</b>
    <table class="sheet-table">
            <tr>
                <th rowspan=3>Amount</th>
                <th colspan=4>Operation</th>
            </tr>
            <tr>
                <th>Move</th>
                <th>Move</th>
                <th>Delete</th>
                <th>Delete</th>
            </tr>
            <tr>
                <th>Forward</th>
                <th>Backward</th>
                <th>Forward</th>
                <th>Backward</th>
            </tr>
            <tr>
                <td>Characters</td>
                <td><code>C-f</code></td>
                <td><code>C-b</code></td>
                <td><code>C-d</code></td>
                <td><code>DEL</code></td>
            </tr>
            <tr>
                <td>Words</td>
                <td><code>M-f</code></td>
                <td><code>M-b</code></td>
                <td><code>M-d</code></td>
                <td><code>M-DEL</code></td>
            </tr>
            <tr>
                <td>Lines</td>
                <td><code>C-n</code></td>
                <td><code>C-p</code></td>
                <td><code>C-k</code></td>
                <td><code>C-SPC C-a C-w</code></td>
            </tr>
            <tr>
                <td>Sentences</td>
                <td><code>M-e</code></td>
                <td><code>M-a</code></td>
                <td><code>M-k</code></td>
                <td><code>C-x DEL</code></td>
            </tr>
            <tr>
                <td>Expressions</td>
                <td><code>C-M-f</code></td>
                <td><code>C-M-b</code></td>
                <td><code>C-M-k</code></td>
                <td><code>C-M-DEL</code></td>
            </tr>
            <tr>
                <td>Paragraphs</td>
                <td><code>M-}</code></td>
                <td><code>M-{</code></td>
                <td>None</td>
                <td>None</td>
            </tr>
            <tr>
                <td>End/Start of Line</td>
                <td><code>C-e</code></td>
                <td><code>C-a</code></td>
                <td>None</td>
                <td>None</td>
            </tr>
            <tr>
                <td>End/Start of Buffer</td>
                <td><code>M-&gt;</code></td>
                <td><code>M-&lt;</code></td>
                <td>None</td>
                <td>None</td> 
            </tr>
        </table>
        
    <div class="sheet-column">
        <b>Scrolling and Windows</b>
        <table class="sheet-table">
            <tr>
                <td><code>C-v</code></td>
                <td>Page Down</td>
            </tr>
            <tr>
                <td><code>M-v</code></td>
                <td>Page Up</td>
            </tr>
            <tr>
                <td><code>C-M-v</code></td>
                <td>Page Down other window</td>
            </tr>
            <tr>
                <td><code>C-x 1</code></td>
                <td>Make current window only window</td>
            </tr>
            <tr>
                <td><code>C-x 2</code></td>
                <td>Split window vertically</td>
            </tr>
            <tr>
                <td><code>C-x 3</code></td>
                <td>Split window horizontally</td>
            </tr>
            <tr>
                <td><code>C-x ^</code></td>
                <td>Grow window vertically</td>
            </tr>
            <tr>
                <td><code>C-x o</code></td>
                <td>Switch to next window</td>
            </tr>
            <tr>
                <td><code>C-x 0</code></td>
                <td>Close current window</td>
            </tr>
        </table>
        
        <b>Cutting and Pasting</b>
        <table class="sheet-table">
            <tr>
                <td><code>C-SPC</code></td>
                <td>Set mark</td>
            </tr>
            <tr>
                <td><code>C-w</code></td>
                <td>Cut (after setting mark and moving to end point)</td>
            </tr>
            <tr>
                <td><code>M-w</code></td>
                <td>Copy (after setting mark and moving to end point)</td>
            </tr>
            <tr>
                <td><code>C-y</code></td>
                <td>Yank (paste) most recently killed (cut or copied)</td>
            </tr>
            <tr>
                <td><code>M-y</code></td>
                <td>Yank next most recently killed</td>
            </tr>
        </table>  
    </div>
    
    <div class="sheet-column">
        <b>Files and Buffers</b>
        <table class="sheet-table">
            <tr>
                <td><code>C-x C-f</code></td>
                <td>Find file (or create if not existing)</td>
            </tr>
            <tr>
                <td><code>C-x C-s</code></td>
                <td>Save file</td>
            </tr>
            <tr>
                <td><code>C-x C-w</code></td>
                <td>Write file</td>
            </tr>
            <tr>
                <td><code>C-x s</code></td>
                <td>Save modified buffers</td>
            </tr>
            <tr>
                <td><code>C-x b</code></td>
                <td>Select buffer</td>
            </tr>
            <tr>
                <td><code>C-x C-b</code></td>
                <td>List buffers</td>
            </tr>
            <tr>
                <td><code>C-x k</code></td>
                <td>Kill buffer</td>
            </tr>
            <tr>
                <td colspan=2>&nbsp;</td>
            </tr>
            <tr>
                <td colspan=2>&nbsp;</td>
            </tr>
        </table>
        
        <b>Command-Related Stuff</b>
        <table class="sheet-table">
            <tr>
                <td><code>ESC ESC ESC</code></td>
                <td>Leave current location</td>
            </tr>
            <tr>
                <td><code>C-u #</code></td>
                <td>Prefix numeric argument # to next command</td>
            </tr>
            <tr>
                <td><code>C-g</code></td>
                <td>Stop running command, or cancel partially entered command</td>
            </tr>
            <tr>
                <td colspan=2>&nbsp;</td>
            </tr>
            <tr>
                <td colspan=2>&nbsp;</td>
            </tr>
        </table>
    </div>
    
    <b>Searching and Replacing</b>
        <table class="sheet-table">
            <tr>
                <td><code>C-s</code></td>
                <td>Incremental search forward</td>
            </tr>
            <tr>
                <td><code>C-r</code></td>
                <td>Incremental search backward</td>
            </tr>
            <tr>
                <td><code>C-M-s</code></td>
                <td>Regexp search forward</td>
            </tr>
            <tr>
                <td><code>C-M-r</code></td>
                <td>Regexp search backward</td>
            </tr>
            <tr>
                <td><code>M-x replace-string RET</code></td>
                <td>String replace from here to end of buffer</td>
            </tr>
            <tr>
                <td><code>M-x query-replace RET</code></td>
                <td>String replace from here to end of buffer, querying for each occurrence</td>
            </tr>
            <tr>
                <td><code>M-x grep RET</code></td>
                <td>Prompts for a grep command, shows hits in a buffer</td>
            </tr>
            <tr>
                <td><code>C-x `</code></td>
                <td>Visit next grep hit</td>
            </tr>
        </table>
    
    <div class="sheet-column">
        <b>Help</b>
        <table class="sheet-table">
            <tr>
                <td><code>C-h k</code></td>
                <td>Show command documentation</td>
            </tr>
            <tr>
                <td><code>C-h a</code></td>
                <td>"Command apropos"</td>
            </tr>
            <tr>
                <td><code>C-h c</code></td>
                <td>Show command name on message line</td>
            </tr>
            <tr>
                <td><code>C-h f</code></td>
                <td>Describe function</td>
            </tr>
            <tr>
                <td><code>C-h i</code></td>
                <td>Info browser</td>
            </tr>
        </table>
    </div>
    
    <div class="sheet-column">
        <b>Misc</b>
        <table class="sheet-table">
            <tr>
                <td><code>C-_ or C-x u</code></td>
                <td>Undo/redo</td>
            </tr>
            <tr>
                <td><code>C-q</code></td>
                <td>Quoted insert</td>
            </tr>
            <!-- Removed because it ruins formatting -->
            <!--<tr>
                <td><code>M-x shell-strip-ctrl-m RET</code></td>
                <td>Flush ^M at end of line</td>
            </tr>-->
            <tr>
                <td><code>C-z</code></td>
                <td>Suspend/iconify emacs (type "%emacs" to return)</td>
            </tr>
            <tr>
                <td><code>C-x C-c</code></td>
                <td>Exit emacs</td>
            </tr>
        </table>
    </div>
</div>',
);

ddg_goodie_test(
    [ qw(DDG::Goodie::EmacsCheatSheet) ],
    'emacs cheatsheet'      => $test_zci,
    'emacs cheat sheet'     => $test_zci,
    'emacs help'            => $test_zci,
    'emacs commands'        => $test_zci,
    'emacs guide'           => $test_zci,
    'emacs reference'       => $test_zci,
    'emacs quick reference' => $test_zci,
);

done_testing;
