package DDG::Goodie::Jira;
# ABSTRACT: returns the URL of an Apache or Codehaus JIRA bug ticket according to its identifier

use strict;
use DDG::Goodie;
use utf8;

zci is_cached   => 1;
zci answer_type => 'jira';

use YAML::XS 'LoadFile';

my $projects = LoadFile(share('projects.yml'));

my @all_project_keys = sort keys %$projects;

my $ticket_keys_regex;

foreach my $project_key (@all_project_keys) {
    $ticket_keys_regex .= join('|', keys %{$projects->{$project_key}->{ticket_keys}});
}

# A ticket identifier is formed by the key of the project and a number: KEY-NUMBER.
triggers query => qr/^(.*\s)*(?<ticket_key>$ticket_keys_regex)\-(?<ticket_number>[\d]{1,})\s*(.*)$/i;

handle query => sub {

    my $ticket_key    = uc $+{ticket_key};
    my $ticket_number = $+{ticket_number};
    my $ticket_id     = $ticket_key . '-' . $ticket_number;

    my $html_return = '';

    foreach my $project_key (@all_project_keys) {
        my $this_project = $projects->{$project_key};
        if (my $ticket_project = $this_project->{ticket_keys}{$ticket_key}) {
            $html_return .= '<br>' if ($html_return);    # We're not first, add a line.
            $html_return .=
                $ticket_project . ' ('
              . $this_project->{description}
              . '): see ticket <a href="'
              . $this_project->{browse_url}
              . $ticket_id . '">'
              . $ticket_id . '</a>.';
        }
    }

    return unless $html_return;

    return undef,
      structured_answer => {
        input     => [$ticket_id],
        operation => "JIRA ticket lookup",
        result    => $html_return
      };
};

1;
