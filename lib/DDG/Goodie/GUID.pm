package DDG::Goodie::GUID;
# ABSTRACT: Generated a GUID on-demand.

use strict;
use DDG::Goodie;
use UUID::Tiny ':std';
use Text::Trim;

my %guid = (
    'guid'                          => 0,
    'uuid'                          => 1,
    'globally unique identifier'    => 0,
    'universally unique identifier' => 1,
    'rfc 4122'                      => 0,
);

# additional allowed triggers
my $allowedTriggers = qr/new|random|generate|generator/i;

triggers any => keys %guid;

zci answer_type => "guid";
zci is_cached   => 0;

handle remainder => sub {

    s/$allowedTriggers//g; # strip allowed triggers

    return if trim $_; # return if other words remaining

    my $guid = create_uuid_as_string(UUID_V4); # generate new version 4 UUID

    return unless $guid; # return if GUID doesn't exist

    return $guid,
      structured_answer => {
          data => {
            title => $guid,
            subtitle => 'Random GUID',
          },
          templates => {
            group => 'text',
          },
      };
};

1;
