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
',
        structured_answer => {
            id => 'UnixPermissions',
            description => 'Unix file permission',
            meta => {
                sourceName => 'wikipedia',
                sourceUrl => 'https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions'
            },
            templates => {
                group => 'list',
                options => {
                    content => 'record',
                },
            },
            data => {
                title => 'Unix file permissions',
                record_keys => ["symbolic", "user", "group", "others", "attributes",],
                record_data => {
                    symbolic => 'rwxr-xr-x',
                    user => 'read, write and execute',
                    group => 'read and execute',
                    others => 'read and execute',
                    attributes => undef,
                },
            },
        },
    ),

    'permission 0644' => test_zci(
'644 (octal)
rw-r--r-- (symbolic)
User: read and write
Group: read
Others: read
',
        structured_answer => {
            id => 'UnixPermissions',
            description => 'Unix file permission',
            meta => {
                sourceName => 'wikipedia',
                sourceUrl => 'https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions'
            },
            templates => {
                group => 'list',
                options => {
                    content => 'record',
                },
            },
            data => {
                title => 'Unix file permissions',
                record_keys => ["symbolic", "user", "group", "others", "attributes",],
                record_data => {
                    symbolic => 'rw-r--r--',
                    user => 'read and write',
                    group => 'read',
                    others => 'read',
                    attributes => undef,
                },
            },
        },
    ),

    'permission 7644' => test_zci(
'7644 (octal)
rwSr-Sr-T (symbolic)
User: read and write
Group: read
Others: read
Attributes: sticky, setuid and setgid
',
        structured_answer => {
            id => 'UnixPermissions',
            description => 'Unix file permission',
            meta => {
                sourceName => 'wikipedia',
                sourceUrl => 'https://en.wikipedia.org/wiki/Permissions#Notation_of_traditional_Unix_permissions'
            },
            templates => {
                group => 'list',
                options => {
                    content => 'record',
                },
            },
            data => {
                title => 'Unix file permissions',
                record_keys => ["symbolic", "user", "group", "others", "attributes",],
                record_data => {
                    symbolic => 'rwSr-Sr-T',
                    user => 'read and write',
                    group => 'read',
                    others => 'read',
                    attributes => 'sticky, setuid and setgid',
                },
            },
        },
    ),

    'permission 9644' => undef,
);
done_testing;
