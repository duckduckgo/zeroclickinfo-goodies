package DDG::Goodie::Git;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "git";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "Git Cheat Sheet";
description "Non-exhaustive list of git commands";
primary_example_queries "git", "git clone";
secondary_example_queries "github commands";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
category "programming";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
topics "computing","programming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Git.pm";
attribution github => ["TheCreatorFr", "TheCreator"],
            twitter => "NicolasBrondin";

# Triggers
triggers any => "git","github";

# Handle statement
handle remainder => sub {

	return html=>"<table>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+init\">git init</a></td><td>Create an empty git repository or reinitialize an existing one</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+clone\">git clone</a></td><td>Clone a repository into a new directory</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+add\">git add</a></td><td>Clone a repository into a new directory</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+pull\">git pull</a></td><td>Fetch from and merge with another repository or a local branch</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+commit\">git commit</a></td><td>Record changes to the repository</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+push\">git push</a></td><td>Update remote refs along with associated objects</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+status\">git status</a></td><td>Show the working tree status</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+log\">git log</a></td><td>Show commit logs</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+diff\">git diff</a></td><td>Show changes between commits, commit and working tree, etc</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+blame\">git blame</a></td><td>Show what revision and author last modified each line of a file</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+revert\">git revert</a></td><td>Revert some existing commits</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+branch\">git branch</a></td><td>List, create, or delete branches</td>
                    </tr>
                    <tr>
                        <td><a href=\"http://duckduckgo.com/?q=git+tag\">git tag</a></td><td>Create, list, delete or verify a tag object signed with GPG</td>
                    </tr>
                  </table>";
};

1;
