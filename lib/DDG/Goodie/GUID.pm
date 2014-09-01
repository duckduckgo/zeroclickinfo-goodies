package DDG::Goodie::GUID;
# ABSTRACT: Generated a GUID on-demand.

use DDG::Goodie;
use Data::GUID;

triggers start => 'globally', 'universally', 'rfc', 'guid', 'uuid';

zci answer_type => "guid";
zci is_cached => 0;

primary_example_queries 'guid';
secondary_example_queries 'uuid';
description 'generate a unique indentifier';
name 'GUID';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GUID.pm';
category 'computing_tools';
topics 'programming';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ,
            twitter => 'loganmccamon',
            github => 'loganom';

my %guid = (
    'guid' => 0,
    'uuid' => 1,
    'globally unique identifier' => 0,
    'universally unique identifier' => 1,
    'rfc 4122' => 0,
    );

handle query_lc => sub {
    return unless exists $guid{$_};
    if (my $guid = Data::GUID->new) {
        my $guid_string = $guid->as_string;

        return  answer => $guid_string,
                html => qq(<input type="text" onclick='this.select();' size="45" value="$guid"/>),
                heading => 'Random GUID';
    }
    return;
};
1;
