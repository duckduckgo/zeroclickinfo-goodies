package DDG::Goodie::VimCheatSheet;
# ABSTRACT: Provide a cheatsheet for common vim syntax

use HTML::Entities;
use DDG::Goodie;
use Text::Xslate;
use JSON;

zci answer_type => "vim_cheat";

name "VimCheatSheet";
description "Vim cheat sheet";
source "http://rtorruellas.com/vim-cheat-sheet/";
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/VimCheatSheet.pm";
category "cheat_sheets";
topics "computing", "geek", "programming", "sysadmin";

primary_example_queries 'vim help', 'vim cheat sheet', 'vim commands';
secondary_example_queries 'vi quick reference', 'vi commands', 'vi guide';

triggers startend => (
    'vi cheat sheet', 
    'vi cheatsheet', 
    'vi commands',
    'vi guide',
    'vi help',
    'vi quick reference',
    'vi reference',
    'vim cheat sheet', 
    'vim cheatsheet', 
    'vim commands',
    'vim guide',
    'vim help',
    'vim quick reference',
    'vim reference',
);

attribution github  => ["kablamo",            "Eric Johnson"],
            twitter => ["kablamo_",           "Eric Johnson"],
            web     => ["http://kablamo.org", "Eric Johnson"];

handle remainder => sub {

    # retrieve data from a file
    my $json     = share("vimcheat.json")->slurp(iomode => '<:encoding(UTF-8)');
    my $columns  = JSON->new->utf8->decode($json);

    return 
        heading => 'Vim Cheat Sheet',
        html    => html($columns), 
        answer  => answer($columns);
};

# Generate an html answer from $columns. Returns a string.
sub html {
    my $columns = shift;

    my $css      = share("style.css")->slurp;
    my $html     = "<style type='text/css'>$css</style>\n";

    my $template = template();
    my $vars     = { columns => $columns };
    $html       .= Text::Xslate->new()->render_string($template, $vars);

    return $html;
}

sub template {
    return <<'EOF';
<div id="vim-container">

  : for $columns -> $tables {
  <div class="vim-column">

    : for $tables -> $table {
    <b><: $table.name :></b>
    <table class="vim-table">

      : for $table.rows -> $row {
      <tr>
        <td>
            : for $row.cmds -> $cmd {
            <code><: $cmd :></code><br>
            : }
        </td>
        <td><: $row.help :></td>
      </tr>
      : }

    </table>
    : }

  </div>
  : }

</div>
EOF
}

# Generate a plain text answer from $columns. Returns a string.
sub answer {
    my $columns = shift;
    my $answer = '';

    foreach my $tables (@$columns) {
        foreach my $table (@$tables) {
            $answer .= $table->{name} . "\n\n";
            foreach my $row (@{ $table->{rows} }) {
                my $cmds = $row->{cmds};
                my $left = join ' or ', @$cmds;

                $answer .= sprintf('%-35s ', $left);
                $answer .= $row->{help};
                $answer .= "\n";
            }
            $answer .= "\n";
        }
        $answer .= "\n";
    }

    return $answer;
}


1;
