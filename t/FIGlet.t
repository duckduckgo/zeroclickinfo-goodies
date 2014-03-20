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
                html => '<pre> ____             _    ____             _    
|  _ \ _   _  ___| | _|  _ \ _   _  ___| | __
| | | | | | |/ __| |/ | | | | | | |/ __| |/ /
| |_| | |_| | (__|   <| |_| | |_| | (__|   < 
|____/ \__,_|\___|_|\_|____/ \__,_|\___|_|\_\
                                             
  ____       
 / ___| ___  
| |  _ / _ \ 
| |_| | (_) |
 \____|\___/ 
             
</pre><span>&quot;DuckDuckGo&quot; rendered in FIGlet font &quot;standard&quot;.</span>',
            ),

        'figlet mini DDG' =>
            test_zci(
                ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                html => '<pre> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</pre><span>&quot;DDG&quot; rendered in FIGlet font &quot;mini&quot;.</span>',
            ),
        
        'figlet-mini DDG' =>
            test_zci(
                ' _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
',
                html => '<pre> _   _   __ 
| \ | \ /__ 
|_/ |_/ \_| 
            
</pre><span>&quot;DDG&quot; rendered in FIGlet font &quot;mini&quot;.</span>',
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
                html => '<pre>     _              
 ___| |_ ___  _ __  
/ __| __/ _ \| \'_ \ 
\__ | || (_) | |_) |
|___/\__\___/| .__/ 
             |_|    
</pre><span>&quot;stop&quot; rendered in FIGlet font &quot;standard&quot;.</span>',
            ),
);

done_testing;
