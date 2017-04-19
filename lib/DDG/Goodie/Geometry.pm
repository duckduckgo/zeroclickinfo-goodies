package DDG::Goodie::Geometry;
# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

use DDG::Goodie;
use strict;


use YAML::XS 'LoadFile';
use Data::Dumper;

zci answer_type => 'geometry';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

my @keyWords = ('geometry', 'formula', 'volume', 'area', 'surface area', 'perimeter', 'circumference', 'diagonal');
my @finalWords;
foreach my $word (@keyWords) {
    push(@finalWords, $word);
    push(@finalWords, $word.' of');
    push(@finalWords, $word.' of a');
}

triggers any => @finalWords;

my ($shapes, $formulas) = LoadFile(share('objectInfo.yml'));

handle remainder => sub {
    
    return unless $_;
    
    my $remainder = lc($_);

    return unless my $shape = $shapes->{$remainder};
    
    my %dataFormula;
    # Fill dataFormula with values for handlebar to parse
    foreach my $key (keys $shape) {
        
       $dataFormula{$key} = {
            'nameCaps' => ucfirst($key),
            'color' => $formulas->{$key}{'color'},
            'symbol' => $formulas->{$key}{'symbol'},
            'html' => $shape->{$key}
        };
        
    }
    
    return "plain text response", structured_answer => {
        data => {
            title => ucfirst($remainder),
            formulas => \%dataFormula,
            svg => LoadFile(share("svg/$remainder.svg")),
        },
        templates => {
            group => "text",
            options => {
                subtitle_content => 'DDH.geometry.subtitle'
            }
        }
    };
};
1;
