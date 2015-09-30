package DDG::Goodie::PackageTracking;
# ABSTRACT: Track a package through some sources trhrough tracking number.

use strict;
use DDG::Goodie;

use YAML qw( Load );

zci is_cached => 1;
zci answer_type => "package_tracking";

primary_example_queries 'CU123456789DK';
secondary_example_queries 'EE123456789HK';
description 'Track a package from some post sources';
name 'PackageTracking';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PackageTracking.pm';
category 'ids';
topics 'special_interest';
attribution github => [ 'https://github.com/duckduckgo', 'duckduckgo'];

my $responses = Load(scalar share("responses.yml")->slurp);
my @response_triggers = ();

foreach my $keyword (keys %$responses) {
    my $response = $responses->{$keyword};
    my $string_trigger = quotemeta $response->{trigger};
    my $regex_trigger = qr/^$response->{trigger}$/i;

    push @response_triggers, $regex_trigger;
}

triggers query_nowhitespace_nodash => @response_triggers;

handle query_nowhitespace_nodash => sub {
    foreach my $keyword (keys %$responses) {
        my $package_number = $1;
        my $response = $responses->{$keyword};
        if ( $package_number =~ /$response->{short_code}/i  ) {
            return handle_one_word_trigger($package_number, $response);
        }
    }
};

sub handle_one_word_trigger {
    my $package_number = $_[0];
    my $response = $_[1];

    return $package_number, heading => 'Tracking Package', html => qq(Track this shipment at <a href="$response->{tracking_url}$package_number">$response->{name}</a>.);
}

1;
