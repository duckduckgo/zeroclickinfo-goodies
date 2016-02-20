package DDG::Goodie::SageExampleSteps;

# ABSTRACT: An example of the format a 'Sage'
# Instant Answer might take. Also see 'CheatSheets'.

# This represents yet another simple use for 'Sage'
# Instant Answers - a list of steps to complete some task.

# This differs from 'SageExample' mostly in that it allows
# aliases, and has a more structured answer.
#
# Additionally, this, like 'CheatSheets', uses the file
# name to produce an example query.

use DDG::Goodie;
use strict;
use File::Find;
use YAML::XS qw(LoadFile);

zci answer_type => 'sage_example_steps';
zci is_cached => 1;

# This builds the triggers for the Controller based
# on specifications in the Sage 'answer' files.
#
# Because the answer processing format would likely be
# very similar across multiple Controllers, it could
# be abstracted out.
sub build_triggers {
    my @files = File::Find::Rule->file()
                                ->name("*.yaml")
                                ->in(share());
   sub build_response {
       my $answer = shift;
       return {
           steps => $answer->{steps},
           title => $answer->{title},
       };
   }
   my %responses;
   foreach my $file (@files) {
       my $yaml = LoadFile($file) or warn "Error reading file: $file\n" and next;
       $file =~ /\/([\w-]+)\.yaml/;
       my $name = $1 =~ s/-/ /gr;
       my $steps = $yaml->{steps};
       my @queries = ($name);
       push @queries, @{$yaml->{aliases}} if exists $yaml->{aliases};
       foreach my $query (@queries) {
           $responses{$query} = $yaml;
       }
   }
   return %responses;
}

my %responses = build_triggers();

triggers startend => keys %responses;

handle remainder => sub {
    my $remainder = $_;

    return if $remainder;

    my $trigger = $req->matched_trigger;
    $trigger =~ s/[^a-zA-Z ]//g;

    my $response = $trigger;
    my $answer = $responses{lc $trigger};
    my @step_vals = @{$answer->{steps}};
    my $title = $answer->{title};

    my @step_keys = (1..@step_vals);
    my %steps = map { $_ => $step_vals[$_ - 1] } @step_keys;

    return "Sage Example Steps",
        structured_answer => {

            id => 'sage_example_steps',
            name => 'Answer',

            data => {
              title => "$title",
              record_data => \%steps,
              record_keys => \@step_keys,
            },

            templates => {
                group => "list",
                options => {
                    content => 'record',
                },
            }
        };
};

1;
