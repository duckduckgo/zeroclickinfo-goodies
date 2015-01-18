package DDG::Goodie::LinuxFounder;
# ABSTRACT: Linux Founder instant answer

use DDG::Goodie;

zci answer_type => "linux_founder";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "LinuxFounder";
description "Answers the question of who is the founder of linux";
primary_example_queries "linux founder", "founder of linux";
secondary_example_queries "founder of linux operating system", "who is the founder of linux operating system";
category "q/a";
topics "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/LinuxFounder.pm";
attribution github => ["dhuette13", "Daniel Huette"];

# Triggers
triggers any => "linux founder", "founder of linux", "founder of linux operating system", "who is the founder of linux operating system";

# Handle statement
handle remainder => sub {
	return if $_; # Guard against "no answer"
    
	return "Linus Torvalds is the founder and creator of Linux",
        structured_answer => {
            input => ["Linux Founder"],
            operation => "Answer",
            result => "Linus Torvalds"
        };
};

1;
