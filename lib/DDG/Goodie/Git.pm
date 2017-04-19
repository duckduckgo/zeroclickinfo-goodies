package DDG::Goodie::Git;
# ABSTRACT: Some git commands with simple description and links to specific instant answers

use DDG::Goodie;

zci answer_type => "git";
zci is_cached   => 1;

name "Git Cheat Sheet";
description "Non-exhaustive list of git commands";
primary_example_queries "git", "git clone";
secondary_example_queries "github commands";
category "programming";
topics "computing","programming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Git.pm";
attribution web => ['http://thecreator.fr', 'Nicolas Brondin'],
         github => ['https://github.com/TheCreatorFr', 'Nicolas Brondin'],
        twitter => ['https://twitter.com/nicolasbrondin', 'Nicolas Brondin'];

# Triggers
triggers startend => (
"git cheat sheet", "cheat sheet git",
"git cheatsheet", "cheatsheet git",
"git help", "help git",
"git quick reference", "quick reference git",
"git reference", "reference git"
);

# Handle statement
handle remainder => sub {
    # All the following infos come from existing git instant answers and the official git documentation.
	return heading => "Git Commands Cheat Sheet",
           html    => html_cheat_sheet(),
           answer  => html_cheat_sheet()
};

my $HTML;

sub html_cheat_sheet {
    $HTML //= share("git_cheat_sheet.html")
        ->slurp(iomode => "<:encoding(UTF-8)");
    return $HTML;
}

1;
