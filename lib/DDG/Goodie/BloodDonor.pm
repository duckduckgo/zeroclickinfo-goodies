package DDG::Goodie::BloodDonor;
# ABSTRACT: Returns available donors for a blood type

use strict;
use DDG::Goodie;

use strict;
use warnings;

triggers startend =>    'donor compatibility', 'donor', 'donors for',
                        'blood donor', 'blood donors for', 'blood donor for',
                        'blood type', 'blood compatibility', 'compatibility', 'blood donor compatibility';

zci answer_type => "blood_donor";
zci is_cached   => 1;

my %typeMap = (
    'A' => 'A,O',
    'O' => 'O',
    'AB' => 'AB,A,B,O',
    'B' => 'B,O',
);

handle remainder => sub {
    
    return unless ($_ =~ /^(O|A|B|AB)((\-|\+)|(\-ve|\+ve))$/i);

    my $type = uc $1;
    my $rh = $2;

    my @idealResults = ();
    my @criticalResults = ();

    return unless defined $typeMap{$type};

    # ideally same Rh
    foreach our $donorType (split(",", $typeMap{$type})) {
        push(@idealResults, $donorType . $rh);
        if($rh eq '+') {
            # only when access to same Rh is impossible
            push(@criticalResults, $donorType . '-');
        } 
        if($rh eq '+ve') {
            push(@criticalResults, $donorType . '-ve');
        }
    }

    my $idealStr = join(' or ', @idealResults);
    my $criticalStr = join(' or ', @criticalResults);

    my %record_data = (
        "Ideal donor" => uc($_),
        "Other donors" => $idealStr,
    );
    my @record_keys = ("Ideal donor", "Other donors");
    
    if($rh eq '+ve' || $rh eq '+') {
        push @record_keys,"Only if no Rh(+) found";
        $record_data{"Only if no Rh(+) found"} = $criticalStr;
    }

    sub to_text
    {
        my ($data, $keys) = @_;
        return join "\n", map {"$_: $data->{$_}";} @{$keys};
    }

    return to_text(\%record_data, \@record_keys), structured_answer => {
            description => 'Returns available donors for a blood type',
            meta => {
                sourceName => 'Wikipedia',
                sourceUrl => 'https://en.wikipedia.org/wiki/Blood_type',
            },
            templates => {
                group => 'list',
                options => {
                    content => 'record'
                }
            },
            data => {
                title => "Donors for blood type ".uc($_),
                record_data => \%record_data,
                record_keys => \@record_keys
            }
        };
};
1;
