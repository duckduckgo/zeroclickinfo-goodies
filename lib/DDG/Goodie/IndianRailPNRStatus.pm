package DDG::Goodie::IndianRailPNRStatus;
# ABSTRACT: Gives the PNR status of the Indian Railway ticket

use DDG::Goodie;
use LWP::Simple;
use JSON qw(decode_json);
use POSIX;

zci answer_type => "indian_rail_pnrstatus";
zci is_cached   => 1;

name "IndianRailPNRStatus";
description "Gives the PNR status of the Indian Railway ticket";
primary_example_queries "pnr 12345";
category "special";
topics "travel";
code_url "https://github.com/jee1mr/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IndianRailPNRStatus.pm";
attribution github => ["https://github.com/jee1mr", "jee1mr"],
            twitter => "jee1mr";

# Triggers
triggers any => "pnr";

# Handle statement
handle remainder => sub {
	if(isdigit($_) && length($_)==10){
		my $contents = get("http://api.erail.in/pnr?key=e9d415f5-1029-4bac-b6e2-b3561b1f4214&pnr=" . $_);
    	my $decoded = decode_json($contents);
    	if($decoded->{"status"} eq "OK"){
    		return "Status: ".$decoded->{"result"}->{"passengers"}[0]->{"currentstatus"};
    	}
	}
    return;
};

1;