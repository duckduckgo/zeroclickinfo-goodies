package DDG::Goodie::Speedtest;
# Checks internet speed

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'speedtest';

zci is_cached => 1;

triggers any => 'speed test', 
                'speedtest', 
                'net speed', 
                'network speed', 
                'network speed test',
                'internet speed';

# Handle statement
handle remainder => sub {

    my $remainder = $_;

    return '',
        structured_answer => {
        
            id => 'speed_test',
            
            data => {
                title    => 'Network Speed Test',
                subtitle => 'Powered By Fast - Netflix'
            },
            
            meta => {
                sourceName => 'Fast.com',
                sourceUrl => 'https://fast.com'
            },

            templates => {
                group => 'info',
                options => {
                    content => 'DDH.speedtest.content'
                }
            }
        };
};

1;
