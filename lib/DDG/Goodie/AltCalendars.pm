package DDG::Goodie::AltCalendars;
# ABSTRACT: Convert non-Gregorian years to the Gregorian calendar

use strict;
use DDG::Goodie;

triggers any => 'juche', 'minguo', 'meiji', 'taisho', 'taishou', 'showa', 'shouwa', 'heisei';

zci answer_type => 'date_conversion';
zci is_cached => 1;

my %eras = (
    'Meiji' => [1867, 'Meiji_period'], # Japanese Meiji era
    'Taisho' => [1911, 'Taisho_period'], # Japanese Taisho era
    'Taishou' => [1911, 'Taisho_period'], # Alternative spelling of "Taisho"
    'Showa' => [1925, 'Showa_period'], # Japanese Showa era
    'Shouwa' => [1925, 'Showa_period'], # Alternative spelling of "Showa"
    'Heisei' => [1988, 'Heisei_period'], # Japanese Heisei era
    'Juche' => [1911, 'North_Korean_calendar'], # North Korean Juche era
    'Minguo' => [1911, 'Minguo_calendar'], # ROC (Taiwanese) Minguo era
);

handle query_parts => sub {
    # Ignore single word queries
    return unless scalar(@_) > 1;

    if ($_ =~ /^(.*\b)(meiji|taisho|taishou|showa|shouwa|heisei|juche|minguo)\s+(\d*[1-9]\d*)(\b.*)$/i) {
        my $era_name = ucfirst($2);
        my $era_year = $3;
        my $year = $eras{$era_name}[0] + $era_year;
        my $result = $1.$year.$4;
        my $wiki = 'https://en.wikipedia.org/wiki/';

        my $answer = "$era_name $era_year is equivalent to $year in the Gregorian Calendar";

        return $answer,
            structured_answer => {
                id => 'altcalendars',
                name => 'Answer',
                data => {
                    title => $year,
                    subtitle => "$era_name $era_year - Equivalent Gregorian Year"
                },
                meta => {
                    sourceName => "Wikipedia",
                    sourceUrl => "$wiki$eras{$era_name}[1]"
                },
                templates => {
                    group => 'info',
                    options => {
                        moreAt => 1
                    }
                }
        };
    }

    return;
};

1;
