package DDG::Goodie::IPCodes;
# ABSTRACT: International Protection Marking Codes

use strict;
use DDG::Goodie;

zci answer_type => "ipcodes";
zci is_cached   => 1;

name "IPCodes";
description "International Protection Marking Codes";
primary_example_queries "IP68", "IP4X";
category "reference";
topics "special_interest";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IPCodes.pm";
attribution github => ["mattr555", "Matt Ramina"],
            twitter => "mattr555";

my $regex = qr/^ip\s?([0-6x])([0-8x]|6k|9k)$/;
triggers query_lc => $regex;

my %particles = (
	"0" => "None",
	"1" => "Back of hand",
	"2" => "Fingers",
	"3" => "Tools",
	"4" => "Wire",
	"5" => "Dust protected",
	"6" => "Dust tight",
	"X" => "Unspecified"
);

my %water = (
	"0" => "None",
	"1" => "Dripping water",
	"2" => "Dripping water, object tilted",
	"3" => "Spraying water",
	"4" => "Splashing water",
	"5" => "Water jets",
	"6" => "Powerful water jets",
	"6K" => "Powerful water jets, high pressure",
	"7" => "Immersion to 1 m",
	"8" => "Immersion greater than 1 m",
	"9K" => "Powerful water jets, high temperature, high pressure",
	"X" => "Unspecified"
);

handle query_lc => sub {
    return unless $regex;
    my ($d, $w) = ($1, $2);

    my $answer = "Particle protection: $particles{$d}; Water protection: $water{$w}";
    return $answer,
    	structured_answer => {
    		input => ["IP$d$w"],
    		operation => "IP Code",
    		result => $answer
    	};
};

1;
