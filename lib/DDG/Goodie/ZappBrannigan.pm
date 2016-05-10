package DDG::Goodie::ZappBrannigan;
# ABSTRACT: Zapp Brannigan quotes.

use strict;
use DDG::Goodie;

use YAML::XS 'LoadFile';

triggers any => "zapp", "brannigan";

zci answer_type => 'zapp_brannigan';
zci is_cached   => 0;

my $quotes = LoadFile(share('quotes.yml'));

handle query => sub {
    return unless $_ =~ m/quotes?/;

    # Ensure rand is seeded for each process
    srand();
    my @quote = @{$quotes->[int(rand(scalar(@$quotes)))]};

    return join("\n", @quote),
      structured_answer => {
        data => {
            content => join("<br>", @quote),
            subtitle => 'Zapp Brannigan quote'            
        },
        templates => {
            group => "text",
            options => {
                content => 'DDH.zapp_brannigan.content'
            }
        }        
      };
};

1;