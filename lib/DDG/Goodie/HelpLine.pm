package DDG::Goodie::HelpLine;
# ABSTRACT: Provide localized suicide intervention phone numbers.

use strict;
use DDG::Goodie;

use YAML::XS 'LoadFile';

my $triggers = LoadFile(share('triggers.yml'));

triggers any => @$triggers;

zci answer_type => 'helpline';
zci is_cached   => 0;

my $helplines = LoadFile(share('helplines.yml'));
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
