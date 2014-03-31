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
                ' ____             _    ____             _    
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __
| | | | | | |/ __| |/ | | | | | | |/ __| |/ /
| |_| | |_| | (__|   <| |_| | |_| | (__|   < 
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\
                                             
  ____       
 / ___| ___  
| |  _ / _ \ 
| |_| | (_) |
 \____|\___/ 
             
',
                html => '<style type=\'text/css\'>#zero_click_wrapper #figlet-wrapper {
    overflow: auto;
}

#zero_click_wrapper #figlet-wrapper pre {
    background-color: inherit;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>standard</pre></span><pre> ____             _    ____             _    
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __
| | | | | | |/ __| |/ | | | | | | |/ __| |/ /
| |_| | |_| | (__|   <| |_| | |_| | (__|   < 
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\
                                             
  ____       
 / ___| ___  
| |  _ / _ \ 
| |_| | (_) |
 \____|\___/ 
             
</pre></div>',
		heading => 'DuckDuckGo (FIGlet)',
            ),

        'bigtext mini DDG' =>
            test_zci(
                ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                html => '<style type=\'text/css\'>#zero_click_wrapper #figlet-wrapper {
    overflow: auto;
}

#zero_click_wrapper #figlet-wrapper pre {
    background-color: inherit;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>mini</pre></span><pre> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</pre></div>',
		heading => 'DDG (FIGlet)',
            ),
        
        'figlet-mini DDG' =>
            test_zci(
                ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                html => '<style type=\'text/css\'>#zero_click_wrapper #figlet-wrapper {
    overflow: auto;
}

#zero_click_wrapper #figlet-wrapper pre {
    background-color: inherit;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>mini</pre></span><pre> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</pre></div>',
		heading => 'DDG (FIGlet)',
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
                html => '<style type=\'text/css\'>#zero_click_wrapper #figlet-wrapper {
    overflow: auto;
}

#zero_click_wrapper #figlet-wrapper pre {
    background-color: inherit;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>standard</pre></span><pre>     _              
 ___| |_ ___  _ __  
/ __| __/ _ \| \'_ \ 
\__ | || (_) | |_) |
|___/\__\___/| .__/ 
             |_|    
</pre></div>',
		heading => 'stop (FIGlet)',
            ),

		'DuckDuckGo bigtext' =>
            test_zci(
                ' ____             _    ____             _    
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __
| | | | | | |/ __| |/ | | | | | | |/ __| |/ /
| |_| | |_| | (__|   <| |_| | |_| | (__|   < 
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\
                                             
  ____       
 / ___| ___  
| |  _ / _ \ 
| |_| | (_) |
 \____|\___/ 
             
',
                html => '<style type=\'text/css\'>#zero_click_wrapper #figlet-wrapper {
    overflow: auto;
}

#zero_click_wrapper #figlet-wrapper pre {
    background-color: inherit;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>standard</pre></span><pre> ____             _    ____             _    
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __
| | | | | | |/ __| |/ | | | | | | |/ __| |/ /
| |_| | |_| | (__|   <| |_| | |_| | (__|   < 
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\
                                             
  ____       
 / ___| ___  
| |  _ / _ \ 
| |_| | (_) |
 \____|\___/ 
             
</pre></div>',
		heading => 'DuckDuckGo (FIGlet)',
            ),

);

done_testing;
