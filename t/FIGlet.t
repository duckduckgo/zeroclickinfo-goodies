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
                html => '<style type=\'text/css\'>#zero_click_wrapper #figlet-wrapper {
    overflow: auto;
}

#zero_click_wrapper #figlet-wrapper pre {
    background-color: inherit;
}

#zero_click_wrapper #figlet-wrapper textarea {
    display: block;
    word-wrap: normal;
    white-space: pre;
    font-family: monospace;
    border: 0;
    height: 175px;
    width: 100%;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>standard</pre></span><textarea> ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
</textarea></div>',
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

#zero_click_wrapper #figlet-wrapper textarea {
    display: block;
    word-wrap: normal;
    white-space: pre;
    font-family: monospace;
    border: 0;
    height: 175px;
    width: 100%;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>mini</pre></span><textarea> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</textarea></div>',
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

#zero_click_wrapper #figlet-wrapper textarea {
    display: block;
    word-wrap: normal;
    white-space: pre;
    font-family: monospace;
    border: 0;
    height: 175px;
    width: 100%;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>mini</pre></span><textarea> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</textarea></div>',
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

#zero_click_wrapper #figlet-wrapper textarea {
    display: block;
    word-wrap: normal;
    white-space: pre;
    font-family: monospace;
    border: 0;
    height: 175px;
    width: 100%;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>standard</pre></span><textarea>     _              
 ___| |_ ___  _ __  
/ __| __/ _ \| \'_ \ 
\__ | || (_) | |_) |
|___/\__\___/| .__/ 
             |_|    
</textarea></div>',
		heading => 'stop (FIGlet)',
            ),

		'DuckDuckGo bigtext' =>
            test_zci(' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
                html => '<style type=\'text/css\'>#zero_click_wrapper #figlet-wrapper {
    overflow: auto;
}

#zero_click_wrapper #figlet-wrapper pre {
    background-color: inherit;
}

#zero_click_wrapper #figlet-wrapper textarea {
    display: block;
    word-wrap: normal;
    white-space: pre;
    font-family: monospace;
    border: 0;
    height: 175px;
    width: 100%;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>standard</pre></span><textarea> ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
</textarea></div>',
		heading => 'DuckDuckGo (FIGlet)',
            ),

		'DuckDuckGo big text' =>
            test_zci(' ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
',
                html => '<style type=\'text/css\'>#zero_click_wrapper #figlet-wrapper {
    overflow: auto;
}

#zero_click_wrapper #figlet-wrapper pre {
    background-color: inherit;
}

#zero_click_wrapper #figlet-wrapper textarea {
    display: block;
    word-wrap: normal;
    white-space: pre;
    font-family: monospace;
    border: 0;
    height: 175px;
    width: 100%;
}

#zero_click_wrapper #figlet-wrapper span pre {
    display: inline-block;
}

@media screen and (max-width:768px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #zero_click_wrapper #figlet-wrapper textarea {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><span>Font: <pre>standard</pre></span><textarea> ____             _    ____             _     ____       
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __/ ___| ___  
| | | | | | |/ __| |/ | | | | | | |/ __| |/ | |  _ / _ \ 
| |_| | |_| | (__|   <| |_| | |_| | (__|   <| |_| | (_) |
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\\\____|\___/ 
                                                         
</textarea></div>',
		heading => 'DuckDuckGo (FIGlet)',
            ),
		'figlet' => undef,
		'bigtext' => undef,
		'big text' => undef,
);

done_testing;
