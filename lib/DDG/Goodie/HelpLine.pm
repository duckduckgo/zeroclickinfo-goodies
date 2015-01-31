package DDG::Goodie::HelpLine;
# ABSTRACT: Provide localized suicide intervention phone numbers.

use DDG::Goodie;

use YAML::XS qw( Load );

my $triggers = Load(scalar share('triggers.yml')->slurp);

triggers any => @$triggers;

zci answer_type => 'helpline';
zci is_cached   => 0;

primary_example_queries 'suicide hotline';
description 'Checks if a query with the word "suicide" was made and returns a 24 hr suicide hotline.';
attribution github  => ['https://github.com/conorfl', 'conorfl'];
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Helpline.pm';
topics 'everyday';
category 'special';
source 'https://en.wikipedia.org/wiki/List_of_suicide_crisis_lines';

my $helplines = Load(scalar share('helplines.yml')->slurp);
my %suicide_phrases = map { $_ => 1 } @$triggers;

handle query_lc => sub {
    my $query = shift;

    return unless exists $suicide_phrases{$query};

    # Display the result.
    my $helpline = $helplines->{$loc->country_code};
    return unless $helpline;

    my @contacts       = @{$helpline->{contacts}};
    my $numbers_string = join(', ', map { ($_->{for_kids}) ? $_->{phone} . ' (kids)' : $_->{phone}; } @contacts);
    my $operation      = '24 Hour Suicide Hotline';
    $operation .= 's' if (scalar @contacts > 1);
    $operation .= ' in ' . $helpline->{display_country};

    return $operation . ": " . $numbers_string,
      structured_answer => {
        input     => [],
        operation => $operation,
        result    => $numbers_string,
      };
};

1;
