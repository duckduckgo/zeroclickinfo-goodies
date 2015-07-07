package DDG::Goodie::IsAwesome::abhijainn27;


use DDG::Goodie;

zci answer_type => "is_awesome_abhijainn27";
zci is_cached   => 1;


name "IsAwesome abhijainn27";
description "Succinct explanation of what this instant answer does";
primary_example_queries "duckduckhack abhijainn27";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/abhijainn27.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "abhijainn27";


triggers start => "duckduckhack abhijainn27";


handle remainder => sub {
    return if $_;
	return "abhijainn27 is a DDG user and has successfully completed the DuckDuckHack Goodie tutorial!";

	return unless $_; # Guard against "no answer"

	return $_;
};

1;
