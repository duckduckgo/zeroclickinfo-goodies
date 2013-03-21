package DDG::Goodie::UnixPermissions;

use strict;

use DDG::Goodie;

triggers any => 'chmod', 'permission', 'permissions';
zci is_cached => 1;
zci answer_type => 'unix_permissions';

primary_example_queries 'chmod 755';
secondary_example_queries 'permission 0644';
description 'Returns the textual description of file modes in UNIX';
attribution github => ['https://github.com/koosha--', 'koosha--'],
            twitter => '_koosha_';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UnixPermissions.pm';
category 'computing_tools';

handle query => sub {
    my $query = $_;
    s/\s*(chmod|permissions?)\s*//g;
    return unless /^(?:0|1|2|4)?([0-7]{3})$/;

    my @modes_desc = (
        'No permission',
        'Execute',
        'Write',
        'Write and execute',
        'Read',
        'Read and execute',
        'Read and write',
        'Read, write and execute'
    );

    my @digits = split '', $1;
    my @modes = qw(--- --x -w- -wx r-- r-x rw- rwx);
    my $plain_output  = "$1 (octal)\n";
       $plain_output .= join('', map($modes[$_], @digits))   . " (symbolic)\n" .
                       'User: '   . $modes_desc[$digits[0]] . "\n" .
                       'Group: '  . $modes_desc[$digits[1]] . "\n" .
                       'Others: ' . $modes_desc[$digits[2]] . "\n";
    (my $html_output = $plain_output) =~ s/\n/<br>/g;

    $plain_output .= 'More at https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions';
    $html_output  .= 'More at <a href="https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions">https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions</a>';

    return $plain_output, html => $html_output, heading => "$query (Unix Permissions)";
};

1;
