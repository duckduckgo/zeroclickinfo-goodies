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
User: Read, write and execute
Group: Read and execute
Others: Read and execute
More at https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions',

    html => '755 (octal)<br>rwxr-xr-x (symbolic)<br>User: Read, write and execute<br>Group: Read and execute<br>Others: Read and execute<br>More at <a href="https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions">https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions</a>',

    heading => 'chmod 755 (Unix Permissions)'),

    'permission 0644' => test_zci(
'644 (octal)
rw-r--r-- (symbolic)
User: Read and write
Group: Read
Others: Read
More at https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions',

    html => '644 (octal)<br>rw-r--r-- (symbolic)<br>User: Read and write<br>Group: Read<br>Others: Read<br>More at <a href="https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions">https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions</a>',

    heading => 'permission 0644 (Unix Permissions)')
);

done_testing;
