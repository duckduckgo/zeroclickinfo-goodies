package DDG::Goodie::SageExample;

# ABSTRACT: An example of the format a 'Sage'
# Instant Answer might take. Also see 'CheatSheets'.

# This represents probably the most basic and simple Sage
# (Controller) you could make: the answer files it accepts
# simply consisting of queries and responses.

use DDG::Goodie;
use strict;
use File::Find;
use YAML::XS qw(LoadFile);

zci answer_type => 'sage_example';
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
       my ($query, $response) = @_;
       return {
           original_query => $query,
           response       => $response,
       };
   }
   my %responses;
   foreach my $file (@files) {
       my $yaml = LoadFile($file) or warn "Error reading file: $file\n" and next;
       while (my ($id, $answer) = each $yaml) {
           foreach my $query (@{$answer->{queries}}) {
               $responses{lc $query} = build_response($query, $answer->{response});
           }
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

    my $answer = $responses{lc $trigger};
    my $response = $answer->{response};
    my $formatted_input = $answer->{original_query};

    return "$response",
        structured_answer => {

            id => 'sage_example',
            name => 'Answer',

            data => {
              title => "$response",
              subtitle => "$formatted_input",
            },

            templates => {
                group => "text",
            }
        };
};

1;
