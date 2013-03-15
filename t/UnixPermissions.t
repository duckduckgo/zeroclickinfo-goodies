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
'rwxr-xr-x
User: Read, write and execute
Group: Read and execute
Others: Read and execute
Find out more on this: https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions',
        html =>
        'rwxr-xr-x<br>User: Read, write and execute<br>Group: Read and execute<br>Others: Read and execute<br>Find out more on this: <a href="https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions">https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions</a>'),
    'permission 0644' => test_zci(
'rw-r--r--
User: Read and write
Group: Read
Others: Read
Find out more on this: https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions',
        html =>
        'rw-r--r--<br>User: Read and write<br>Group: Read<br>Others: Read<br>Find out more on this: <a href="https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions">https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions</a>')
);

done_testing;
