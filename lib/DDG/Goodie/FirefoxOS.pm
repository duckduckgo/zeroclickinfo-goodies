package DDG::Goodie::FirefoxOS;
# ABSTRACT: Get details of the Firefox OS device APIs.

use strict;
use DDG::Goodie;
use YAML::XS 'LoadFile';
use Text::Trim;

triggers any => 'fxos', 'firefoxos', 'firefox os';

zci answer_type => 'firefoxos';
zci is_cached => 1;

my $apis = LoadFile(share('apis.yml'));

# Get the content of the YAML file and parse the keys and aliases
foreach my $keyword (keys %$apis) {
    my $api = $apis->{$keyword};
    if (ref($api->{aliases}) eq 'ARRAY') {
        foreach my $alias (@{$api->{aliases}}) {
            # Assume we didn't add an alias for an existing keyword.
            $apis->{$alias} = $api;
        }
    }
    foreach my $key (keys %$api) {
        # No matter what they added, we only use the following keys for the actual response.
        delete $api->{$key} unless (grep { $key eq $_ } (qw(permission name description app_type access granted platform url)));
    }
}

handle remainder => sub {
    my $key = lc;

    # Check for the existence of "api" and remove from query
    return unless my ($a, $b) = $_ =~ /^(.*)(?:api)(.*)$/i;
    
    $key = trim $a . ' ' . trim $b;
    
    my $api = $apis->{$key};

    return unless ($api);
    
    return $api->{permission},
      structured_answer => {
        data => {
            title => $api->{name},
            subtitle => "Manifest permission: " . $api->{permission},
            description => $api->{description},
            url => $api->{url},
            infoboxData => [{
                label => "Minimum app type required",
                value => $api->{app_type}
            }, {
                label => "'access' property",
                value => $api->{access}
            }, {
                label => "Default granted",
                value => $api->{granted}
            }, {
                label => "Platform/version supported",
                value => $api->{platform}
            }]
        },
        meta => {
            sourceName => "Mozilla Developer Network",
            sourceUrl => "https://developer.mozilla.org/en-US/Apps/Reference/Firefox_OS_device_APIs" 
        }, 
        templates => {
            group => "info",       
            options => {
                moreAt => 1
            }
        }};
};

1;
