#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'figlet';
zci is_cached => 1;

ddg_goodie_test(
    [
        'DDG::Goodie::FIGlet'
    ],
    'figlet DuckDuckGo' => test_zci(
        ' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
        structured_answer => {
            data => {
                title => ' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
                subtitle => "Font: standard",
            },
            templates => {
                group => 'text',
            }
        }            
    ),

   'bigtext mini DDG' => test_zci(
       ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
        structured_answer => {
            data => {
                title => ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                subtitle => "Font: mini",
            },
            templates => {
                group => 'text',
            }
        } 
    ),
        
    'figlet-mini DDG' => test_zci(
        ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
        structured_answer => {
            data => {
                title => ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                subtitle => "Font: mini",
            },
            templates => {
                group => 'text',
            }
        }
    ),

    'figlet-stop' => test_zci(
        '     _              
 ___| |_ ___  _ __  
/ __| __/ _ \| \'_ \ 
\__ | || (_) | |_) |
|___/\__\___/| .__/ 
             |_|    
',
        structured_answer => {
            data => {
                title => '     _              
 ___| |_ ___  _ __  
/ __| __/ _ \| \'_ \ 
\__ | || (_) | |_) |
|___/\__\___/| .__/ 
             |_|    
',
                subtitle => "Font: standard",
            },
            templates => {
                group => 'text',
            }
        }
    ),

    'DuckDuckGo bigtext' => test_zci(
        ' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
        structured_answer => {
            data => {
                title => ' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
                subtitle => "Font: standard",
            },
            templates => {
                group => 'text',
            }
        }
    ),

	'DuckDuckGo big text' => test_zci(
        ' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
        structured_answer => {
            data => {
                title => ' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
                subtitle => "Font: standard",
            },
            templates => {
                group => 'text',
            }
        }
    ),
    
	'figlet rot13 </fpevcg>' => test_zci(
        "</script>
",
        structured_answer => {
            data => {
                title => "</script>
",
                subtitle => "Font: rot13",
            },
            templates => {
                group => 'text',
            }
        }
    ),
    
	'figlet mnemonic </script>' => test_zci(
        "</script>
",
        structured_answer => {
            data => {
                title => "</script>
",
                subtitle => "Font: mnemonic",
            },
            templates => {
                group => 'text',
            }
        }
    ),
    
	'figlet term </script>' => test_zci(
        "</script>
",
        structured_answer => {
            data => {
                title => "</script>
",
                subtitle => "Font: term",
            },
            templates => {
                group => 'text',
            }
        }
    ),    
    
	'figlet' => undef,
	'bigtext' => undef,
	'big text' => undef,
);

done_testing;
