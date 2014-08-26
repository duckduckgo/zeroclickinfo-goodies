#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'figlet';
zci is_cached => 1;

ddg_goodie_test(
        [
            'DDG::Goodie::FIGlet'
        ],
        'figlet DuckDuckGo' =>
            test_zci(
                ' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
                html => '<div id=\'figlet-wrapper\'><span>Font: </span><span id=\'figlet-font\'>standard</span><pre contenteditable=\'true\'> ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
</pre></div>',
            ),

        'bigtext mini DDG' =>
            test_zci(
                ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                html => '<div id=\'figlet-wrapper\'><span>Font: </span><span id=\'figlet-font\'>mini</span><pre contenteditable=\'true\'> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</pre></div>',
            ),
        
        'figlet-mini DDG' =>
            test_zci(
                ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                html => '<div id=\'figlet-wrapper\'><span>Font: </span><span id=\'figlet-font\'>mini</span><pre contenteditable=\'true\'> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</pre></div>',
            ),

        'figlet-stop' =>
            test_zci(
                '     _              
 ___| |_ ___  _ __  
/ __| __/ _ \| \'_ \ 
\__ | || (_) | |_) |
|___/\__\___/| .__/ 
             |_|    
',
                html => '<div id=\'figlet-wrapper\'><span>Font: </span><span id=\'figlet-font\'>standard</span><pre contenteditable=\'true\'>     _              
 ___| |_ ___  _ __  
/ __| __/ _ \| \'_ \ 
\__ | || (_) | |_) |
|___/\__\___/| .__/ 
             |_|    
</pre></div>',
            ),

		'DuckDuckGo bigtext' =>
            test_zci(' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
                html => '<div id=\'figlet-wrapper\'><span>Font: </span><span id=\'figlet-font\'>standard</span><pre contenteditable=\'true\'> ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
</pre></div>',
            ),

		'DuckDuckGo big text' =>
            test_zci(' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
                html => '<div id=\'figlet-wrapper\'><span>Font: </span><span id=\'figlet-font\'>standard</span><pre contenteditable=\'true\'> ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
</pre></div>',
            ),
		'figlet' => undef,
		'bigtext' => undef,
		'big text' => undef,
);

done_testing;
