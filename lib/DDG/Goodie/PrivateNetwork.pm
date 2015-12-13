package DDG::Goodie::PrivateNetwork;
# ABSTRACT: show non-Internet routable IP addresses.

use strict;
use DDG::Goodie;
use YAML::XS 'LoadFile';

triggers start => "private network", "private ip", "private networks", "private ips";

zci is_cached => 1;
zci answer_type => "private_network";

primary_example_queries 'private networks';
secondary_example_queries 'private ips';
description 'show private IP blocks';
name 'PrivateNetwork';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PrivateNetwork.pm';
category 'cheat_sheets';
topics 'sysadmin';
attribution twitter => ['crazedpsyc', 'Michael Smith'],
            cpan    => ['CRZEDPSYC', 'Michael Smith'],
            github  => ["https://github.com/Mailkov", "Melchiorre Alastra"];

my $text = scalar share('private_network.txt')->slurp;
my $list = LoadFile(share("private_network.yml"));

handle sub {
    $text,
    structured_answer => {
        id => 'private_network',
        name => 'Answer',
        data => {
            title => 'Private Network',
            list => $list,
        },
        templates => {
            group => 'list',
            options => {
                list_content => 'DDH.private_network.content',
            }
        }
     };
};

1;
