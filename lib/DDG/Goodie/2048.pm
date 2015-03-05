package DDG::Goodie::2048;
# ABSTRACT: Write an abstract here

use DDG::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

name "2048";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/2048.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers any => "game", "play";

# Handle statement
handle remainder => sub {

	my $base = 128;

	return unless (($_ == $base) || # play 128
					($_ == $base*2) || # play 256
					($_ == $base*4) || # play 512
					($_ == $base*8) || # play 1024
					($_ == $base*16) || # play 2048
					($_ == $base*32) || # play 4096
					($_ == $base*64)); # play 8192

	my $play = '<i><b>Play <span id="game">'. $_ .'</span></b></i>';
	my $html = scalar share('2048.html')->slurp;

	return html => "$play $html";
};

1;
