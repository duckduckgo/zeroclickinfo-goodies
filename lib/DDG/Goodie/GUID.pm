package DDG::Goodie::GUID;
# ABSTRACT: Generated a GUID on-demand.

use strict;
use DDG::Goodie;
use Data::GUID;
use Text::Trim;

my %guid = (
    'guid'                          => 0,
    'uuid'                          => 1,
    'globally unique identifier'    => 0,
    'universally unique identifier' => 1,
    'rfc 4122'                      => 0,
);

# additional allowed triggers
my $allowedTriggers = qr/new|random|generate/i;

triggers any => keys %guid;

zci answer_type => "guid";
zci is_cached   => 0;

handle remainder => sub {

    s/$allowedTriggers//g; # strip allowed triggers

    return if trim $_; # return if other words remaining

    my $guid = Data::GUID->new; # generate new GUID

    return unless $guid; # return if GUID doesn't exist

    return $guid->as_string,
      structured_answer => {
        input     => [],
        operation => 'Random GUID',
        result    => $guid->as_string
      };
};

1;
