#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'color_code';
zci is_cached => 1;

my $green_answer = 'Hex: #00FF00 ~ RGBA(0, 255, 0, 1) ~ RGB(0%, 100%, 0%) ~ HSL(120, 100%, 50%) ~ CMYB(100%, 0%, 100%, 0%)'."\n".'Complementary: #FF00FF'."\n".'Analogous: #00FF80, #80FF00';

my %basic_answer = (
    structured_answer => {
        data => ignore(),
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.color_codes.content'
            }
        }
    }
);

my $data = {                                                                                                                         
        analogous => {'AEBDE6', 'AEE6D7'},                                                                                                                                                   
        cmyb => 'CMYB(25%, 6%, 0%, 10%)',                                                                                                            
        complementary => 'E6BBAE',                                                                                                                            
        hex_code => 'add8e5',                                                                                                                            
        hexc => 'Hex: #ADD8E5',                                                                                                                      
        hslc => 'HSL(194, 53%, 79%)',                                                                                                                
        rgb =>  'RGBA(173, 216, 229, 1)',                                                                                                            
        show_column_2 => '1'                                                                                                                                    
};
    
sub test_structured_answer {
    delete($basic_answer{data});
    $basic_answer{data} = \$data;
    return %basic_answer;
}

sub green_args {
    return ($green_answer, %basic_answer);
}


ddg_goodie_test(
    [qw(DDG::Goodie::ColorCodes)],
    'hex color code for cyan' => test_zci(
        'Hex: #00FFFF ~ RGBA(0, 255, 255, 1) ~ RGB(0%, 100%, 100%) ~ HSL(180, 100%, 50%) ~ CMYB(100%, 0%, 0%, 0%)'."\n".'Complementary: #FF0000'."\n".'Analogous: #0080FF, #00FF80',
        %basic_answer 
    ),
    'RGB(173,216,230)' => test_zci(
        'Hex: #ADD8E6 ~ RGBA(173, 216, 230, 1) ~ RGB(68%, 85%, 90%) ~ HSL(195, 53%, 79%) ~ CMYB(25%, 6%, 0%, 10%)'."\n".'Complementary: #E6BAAC'."\n".'Analogous: #ACBAE6, #ACE6D7',
        %basic_answer 
    ),
    'cmyk(0.12, 0, 0, 0)' => test_zci(
        'Hex: #E0FFFF ~ RGBA(224, 255, 255, 1) ~ RGB(88%, 100%, 100%) ~ HSL(180, 100%, 94%) ~ CMYB(12%, 0%, 0%, 0%)'."\n".'Complementary: #FFE0E0'."\n".'Analogous: #E0F0FF, #E0FFF0',
        %basic_answer
    ),
    '#00ff00' => test_zci(green_args),
    '#0f0' => test_zci(green_args),
    '#0f0 to rgb' => test_zci(green_args),
    '#0f0 to cmyk' => test_zci(green_args),
    'inverse of the color red' => test_zci(
        'Hex: #00FFFF ~ RGBA(0, 255, 255, 1) ~ RGB(0%, 100%, 100%) ~ HSL(180, 100%, 50%) ~ CMYB(100%, 0%, 0%, 0%)'."\n".'Complementary: #FF0000'."\n".'Analogous: #0080FF, #00FF80',
        %basic_answer 
),
    'RGB(0 255 0)\'s inverse' => test_zci(
        'Hex: #FF00FF ~ RGBA(255, 0, 255, 1) ~ RGB(100%, 0%, 100%) ~ HSL(300, 100%, 50%) ~ CMYB(0%, 100%, 0%, 0%)'."\n".'Complementary: #00FF00'."\n".'Analogous: #FF0080, #8000FF',
        %basic_answer
    ),
    'html bluishblack' => test_zci(
        'Hex: #202428 ~ RGBA(32, 36, 40, 1) ~ RGB(13%, 14%, 16%) ~ HSL(210, 11%, 14%) ~ CMYB(20%, 10%, 0%, 84%)'."\n".'Complementary: #292521'."\n".'Analogous: #212129, #212929',
        %basic_answer 
    ),
    'bluishblack html' => test_zci(
        'Hex: #202428 ~ RGBA(32, 36, 40, 1) ~ RGB(13%, 14%, 16%) ~ HSL(210, 11%, 14%) ~ CMYB(20%, 10%, 0%, 84%)'."\n".'Complementary: #292521'."\n".'Analogous: #212129, #212929',
        %basic_answer
    ),
    # Single full HTML check.
    'red html code' => test_zci(
        'Hex: #FF0000 ~ RGBA(255, 0, 0, 1) ~ RGB(100%, 0%, 0%) ~ HSL(0, 100%, 50%) ~ CMYB(0%, 100%, 100%, 0%)'."\n".'Complementary: #00FFFF'."\n".'Analogous: #FF8000, #FF0080',
        %basic_answer 
),
    'RGBA(99,60,176,0.5)' => test_zci(
        'Hex: #633CB0 ~ RGBA(99, 60, 176, 0.5) ~ RGB(39%, 24%, 69%) ~ HSL(260, 49%, 46%) ~ CMYB(44%, 66%, 0%, 31%)'."\n".'Complementary: #89B03C'."\n".'Analogous: #9D3CB0, #3C4FB0',
        %basic_answer 
    ),
    '#dc5f3c' => test_zci(
        'Hex: #DC5F3C ~ RGBA(220, 95, 60, 1) ~ RGB(86%, 37%, 24%) ~ HSL(13, 70%, 55%) ~ CMYB(0%, 57%, 73%, 14%)'."\n".'Complementary: #3BB9DB'."\n".'Analogous: #DBAE3B, #DB3B69',
        %basic_answer
    ),
    #Colours with no hue shouldn't have complements or analogs
    '#000000' => test_zci(
        'Hex: #000000 ~ RGBA(0, 0, 0, 1) ~ RGB(0%, 0%, 0%) ~ HSL(0, 0%, 0%) ~ CMYB(0%, 0%, 0%, 100%)',
        %basic_answer   
    ),
    '#FFFFFF' => test_zci(
        'Hex: #FFFFFF ~ RGBA(255, 255, 255, 1) ~ RGB(100%, 100%, 100%) ~ HSL(0, 0%, 100%) ~ CMYB(0%, 0%, 0%, 0%)',
        %basic_answer
    ),
    'red: 255 green: 255 blue: 255' => test_zci(
        'Hex: #FFFFFF ~ RGBA(255, 255, 255, 1) ~ RGB(100%, 100%, 100%) ~ HSL(0, 0%, 100%) ~ CMYB(0%, 0%, 0%, 0%)',
        %basic_answer
    ),
    'red: 99 green: 60 blue: 176' => test_zci(
        'Hex: #633CB0 ~ RGBA(99, 60, 176, 1) ~ RGB(39%, 24%, 69%) ~ HSL(260, 49%, 46%) ~ CMYB(44%, 66%, 0%, 31%)'."\n".'Complementary: #89B03C'."\n".'Analogous: #9D3CB0, #3C4FB0',
        %basic_answer 
    ),
    'rgb(217,37,50)' => test_zci(
        'Hex: #D92532 ~ RGBA(217, 37, 50, 1) ~ RGB(85%, 15%, 20%) ~ HSL(356, 71%, 50%) ~ CMYB(0%, 83%, 77%, 15%)'."\n".'Complementary: #25D9CD'."\n".'Analogous: #D97325, #D9258B',
        %basic_answer
    ),
    # Check the content of the structured answer. Just once.
    'hsl 194 0.53 0.79' => test_zci(
        'Hex: #ADD8E5 ~ RGBA(173, 216, 229, 1) ~ RGB(68%, 85%, 90%) ~ HSL(194, 53%, 79%) ~ CMYB(25%, 6%, 0%, 10%)'."\n".'Complementary: #E6BBAE'."\n".'Analogous: #AEBDE6, #AEE6D7',
        test_structured_answer 
    ),
    
    # Queries to ignore.
    'HTML email'       => undef,
    'wield color'      => undef,
    'whats the symbolism of the color red' => undef,
    'red color porsche 911' => undef,
    'yoda lightsaber green color' => undef,
    'product red color iphone' => undef,
    'w3 html5.1' => undef,
    'w3c html5.1' => undef
);

done_testing;
