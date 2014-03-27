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
                html => '<style type=\'text/css\'>#figlet-wrapper {
    overflow: auto;
}

@media screen and (max-width:768px) {
    #figlet-wrapper {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #figlet-wrapper {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><pre> ____             _    ____             _    
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __
| | | | | | |/ __| |/ | | | | | | |/ __| |/ /
| |_| | |_| | (__|   <| |_| | |_| | (__|   < 
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\
                                             
  ____       
 / ___| ___  
| |  _ / _ \ 
| |_| | (_) |
 \____|\___/ 
             
</pre></div><span>&quot;DuckDuckGo&quot; rendered in FIGlet font &quot;standard&quot;.</span>',
            ),

        'bigtext mini DDG' =>
            test_zci(
                ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                html => '<style type=\'text/css\'>#figlet-wrapper {
    overflow: auto;
}

@media screen and (max-width:768px) {
    #figlet-wrapper {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #figlet-wrapper {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><pre> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</pre></div><span>&quot;DDG&quot; rendered in FIGlet font &quot;mini&quot;.</span>',
            ),
        
        'figlet-mini DDG' =>
            test_zci(
                ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                html => '<style type=\'text/css\'>#figlet-wrapper {
    overflow: auto;
}

@media screen and (max-width:768px) {
    #figlet-wrapper {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #figlet-wrapper {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><pre> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</pre></div><span>&quot;DDG&quot; rendered in FIGlet font &quot;mini&quot;.</span>',
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
                html => '<style type=\'text/css\'>#figlet-wrapper {
    overflow: auto;
}

@media screen and (max-width:768px) {
    #figlet-wrapper {
        font-size: 10px;
    }
}

@media screen and (max-width:500px) {
    #figlet-wrapper {
        font-size: 5px;
    }
}
</style>
<div id=\'figlet-wrapper\'><pre>     _              
 ___| |_ ___  _ __  
/ __| __/ _ \| \'_ \ 
\__ | || (_) | |_) |
|___/\__\___/| .__/ 
             |_|    
</pre></div><span>&quot;stop&quot; rendered in FIGlet font &quot;standard&quot;.</span>',
            ),
);

done_testing;
