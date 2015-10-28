package DDG::Goodie::ISUP;

use DDG::Goodie;
use LWP::Simple;
use strict;

zci answer_type => "isup";
zci is_cached   => 1;

name "ISUP";
description "Check if given URL is onine or not";
primary_example_queries "isup duckduckgo.com", "is up https://duckduckgo.com";
secondary_example_queries "online duckduckgo.com", "github.com is down";
topics 'computing';
category 'computing_info';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ISUP.pm";
attribution github => ["https://github.com/codenirvana", "Udit Vasu"],
            twitter => "uditdistro";

triggers any => "isup", "isdown", "is up", "is down", "online";

# Handle statement
handle remainder => sub {

    return unless $_;
    
    my $url = $_;
    
    # Prefix http:// if not present
    if (!( $url =~ /^htt(p|ps):\/\/.*$/ )) {
        $url = 'http://' . $url
    }
 
    # URL Validator Regex, from: http://regexlib.com/REDetails.aspx?regexp_id=1854
    return unless ( $url =~ /^(http(?:s)?\:\/\/[a-zA-Z0-9]+(?:(?:\.|\-)[a-zA-Z0-9]+)+(?:\:\d+)?(?:\/[\w\-]+)*(?:\/?|\/\w+\.[a-zA-Z]{2,4}(?:\?[\w]+\=[\w\-]+)?)?(?:\&[\w]+\=[\w\-]+)*)$/ );
   
    # Request URL
    if ( head($url)) {
        return "Seems up!",
          structured_answer => {
            input     => [],
            operation => $_,
            result    => 'Seems up!'
        };
    } else{
        return "Seems to be down!",
          structured_answer => {
            input     => [],
            operation => $_,
            result    => 'Seems to be down!'
        };
    }
    
};

1;
