package DDG::Goodie::Countdown;

# ABSTRACT: Provides a countdown to a particular date or time

use DDG::Goodie;
use strict;

zci answer_type => 'countdown';

zci is_cached => 1;

triggers any => 'countdown to','time until';

# Handle statement
handle remainder => sub {

    return if remainder_is_malformed($_);
    
    return "",
        structured_answer => {
            data => {
                remainder => $_
            },
            templates => {
                group => "text",
            }
        };
};

sub remainder_is_malformed {
    my $remainder = $_;
   
    return 1 unless (($remainder =~ /[\s]*(?:(\d{1,2})\.?(\d{1,2})?)[\s]+([Aa|Pp][Mm])[\s]*(today|tomorrow|(?:(?:Mon|Tues|Wednes|Thurs|Fri|Satur|Sun)(?:day)?))?/i) || ($remainder =~ /[\s]*([\d]{1,2})[\s]*(?:st|th|nd)?[\s]*(?:[\s]+|[\/|-]?)[\s]*(?:(Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sept(?:ember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?|[\d]{1,2}))[\s]*(?:[\s]+|[\/|-]?)[\s]*([\d]{4})[\s]*/i));
    return 0;
}

1;
