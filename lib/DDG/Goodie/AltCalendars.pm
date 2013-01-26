package DDG::Goodie::AltCalendars;
# ABSTRACT: Convert non-Gregorian years to the Gregorian calendar

use DDG::Goodie;

primary_example_queries 'heisei 24';
secondary_example_queries 'meiji 1';
description 'Convert non-Gregorian years to the Gregorian calendar';
name 'Alternative Calendars';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/AltCalendars.pm';
category 'conversions';
topics 'everyday';

attribution web => ['http://kyokodaniel.com/tech/', 'Daniel Davis'],
            github => ['https://github.com/tagawa', 'tagawa'],
            twitter => ['https://twitter.com/ourmaninjapan', 'ourmaninjapan'];

triggers start => 'juche', 'minguo', 'meiji', 'taisho', 'taishou', 'showa', 'shouwa', 'heisei';

zci answer_type => 'date_conversion';
zci is_cached => 1;

handle query_parts => sub {
    return unless scalar(@_) == 2;
    
    my $year = $_[1];
    if ($year =~ /\d*[1-9]\d*/) {
        my $era = lc($_[0]);
        my %eras = (
            'meiji' => 1867, # Japanese Meiji era
            'taisho' => 1911, # Japanese Taisho era
            'taishou' => 1911, # Alternative spelling of "taisho"
            'showa' => 1925, # Japanese Showa era
            'shouwa' => 1925, # Alternative spelling of "showa"
            'heisei' => 1988, # Japanese Heisei era
            'juche' => 1911, # North Korean Juche era
            'minguo' => 1911, # ROC (Taiwanese) Minguo era
        );
        
        return unless exists $eras{$era};
        
        return $year + $eras{$era};
    }

    return ;
};

1;