package DDG::Goodie::PeriodicTable;
# ABSTRACT: Chemical symbols, atomic masses and numbers for chemical elements

use strict;
use DDG::Goodie;
use YAML::XS 'LoadFile';
use List::Util qw(first);
use Text::Trim;

zci answer_type => 'periodic_table';
zci is_cached   => 1;

my @elements = @{ LoadFile(share('elements.yml')) };

# Triggers
my @element_triggers = [map { lc($_->[2]) } @elements];
triggers start => $element_triggers[0];
triggers any => 'atomic mass', 'atomic weight', 'atomic number', 'proton number', 'chemical symbol', 'chemical name';


# Handle statement
handle query_lc => sub {

    my $query = $_;

    # Determine if this is a query for atomic mass or chemical name
    my $is_mass_query = $query =~ /atomic mass|atomic weight/;
    my $is_number_query = $query =~ /atomic number|proton number/;

    # Strip out irrelevant words in the query
    $query =~ s/(?:atomic (?:mass|weight|number)|proton number|of|the|for|element|elemental|chemical symbol|what is|chemical name)//g;
    $query = trim $query;
    return unless $query;

    # Look for a matching element or symbol in the table
    my $match = first { lc $_->[2] eq $query || lc $_->[3] eq $query } @elements or return;
    my ( $atomic_number, $atomic_mass, $element_name, $element_symbol, $element_type ) = @{$match};

    # Default display
    my $title = "$element_name";
    my $raw = "$element_name ($element_symbol), atomic number $atomic_number, atomic mass $atomic_mass u";

    # The text size of the icon needs to change depending on the length of the chemical symbol.
    my $badge_class = "";
    my $symbol_length = length($element_symbol);
    if ($symbol_length == 1) { $badge_class = "tx--25" }
    elsif ($symbol_length == 3) { $badge_class = "tx--14" }

    return $raw, 
    structured_answer => {
        data => {
            badge => $element_symbol,
            title => $title,
            subtitle => 'Chemical Element',
            atomic_number => $atomic_number,
            atomic_mass => $atomic_mass,
            element_type => $element_type,
            is_mass_query => $is_mass_query,
            is_number_query => $is_number_query,
            url => "https://en.wikipedia.org/wiki/$element_name",
        },
        meta => {
            sourceName => "Wikipedia",
            sourceUrl => "https://en.wikipedia.org/wiki/$element_name" 
        }, 
        templates => {
            group => "icon",
            elClass => {
                bgColor => get_badge_color($element_type),
                iconBadge => "tx-clr-white $badge_class",
                iconTitle => "tx--19",
                tileSubtitle => "tx--14"
            },
            variants => {
                iconBadge => "medium"
            },           
            options => {
                content => 'DDH.periodic_table.content',
                moreAt => 1
            }
        }
    };   
    
};

# Decide on a color to use when displaying the element badge based on its group.
sub get_badge_color {
	my ($element_type) = @_;

    # metmetal–metalloid–nonmetal etc is currently split into only 5 color groups.
    # https://github.com/duckduckgo/zeroclickinfo-goodies/issues/927
    my $badge_color = "bg-clr--red";
    if    ($element_type eq "Alkali metal") { $badge_color = "bg-clr--gold" }
    elsif ($element_type eq "Alkaline earth metal") { $badge_color = "bg-clr--gold" }
    elsif ($element_type eq "Lanthanide") { $badge_color = "bg-clr--red" }
    elsif ($element_type eq "Actinide") { $badge_color = "bg-clr--red" }
    elsif ($element_type eq "Transition metal") { $badge_color = "bg-clr--red" }
    elsif ($element_type eq "Post-transition metal") { $badge_color = "bg-clr--green" }
    elsif ($element_type eq "Metalloid") { $badge_color = "bg-clr--green" }
    elsif ($element_type eq "Polyatomic nonmetal") { $badge_color = "bg-clr--green" }
    elsif ($element_type eq "Diatomic nonmetal") { $badge_color = "bg-clr--green" }
    elsif ($element_type eq "Noble gas") { $badge_color = "bg-clr--blue-light" }
    elsif ($element_type eq "Unknown") { $badge_color = "bg-clr--red" }

	return $badge_color;
}

1;
