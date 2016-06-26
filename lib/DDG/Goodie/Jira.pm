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

    my $return_value = {};
    foreach my $project_key (@all_project_keys) {
        my $this_project = $projects->{$project_key};
        if (my $ticket_project = $this_project->{ticket_keys}{$ticket_key}) {
            $return_value->{description} = $this_project->{description};
            $return_value->{url} = $this_project->{browse_url};
            $return_value->{id} = $ticket_id;
            $return_value->{project} = $ticket_project;
        }
    }

    return unless $return_value;

    return undef, structured_answer => {
        data => {
            title => "$return_value->{project} ($return_value->{description})",
            subtitle => "JIRA Ticket Lookup: $return_value->{id}",
            url => "$return_value->{url}$return_value->{id}",
        },
        templates => {
            group => 'info'
        }
    };
};

1;
