use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'unix_permissions';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::UnixPermissions
    )],
    'chmod 755' => test_zci(
'755 (octal)
rwxr-xr-x (symbolic)
User: read, write and execute
Group: read and execute
Others: read and execute
More at https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions',

    html => 'rwxr-xr-x (symbolic)<br>User: read, write and execute<br>Group: read and execute<br>Others: read and execute<br><a href="https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions">More at Wikipedia</a>',

    heading => 'chmod 755 (Unix Permissions)'),

    'permission 0644' => test_zci(
'644 (octal)
rw-r--r-- (symbolic)
User: read and write
Group: read
Others: read
More at https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions',

    html => 'rw-r--r-- (symbolic)<br>User: read and write<br>Group: read<br>Others: read<br><a href="https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions">More at Wikipedia</a>',

    heading => 'permission 0644 (Unix Permissions)')
);

done_testing;
