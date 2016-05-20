package DDG::Goodie::UnixPermissions;
# ABSTRACT: describe UNIX file mode permissions

use strict;

use DDG::Goodie;

triggers any => 'chmod', 'permission', 'permissions';
zci is_cached => 1;
zci answer_type => 'unix_permissions';

handle query => sub {
    my $query = $_;

    s/\s*(unix|files?|chmod|permissions?)\s*//g;
    return unless /^(0|1|2|4|6|7)?([0-7]{3})$/;

    my $plain_output;

    my @modes = qw(--- --x -w- -wx r-- r-x rw- rwx);

    my @modes_desc = (
        'no permission',
        'execute',
        'write',
        'write and execute',
        'read',
        'read and execute',
        'read and write',
        'read, write and execute'
    );

    my %attributes = (
        0 => 'no special attributes',
        1 => 'sticky',
        2 => 'setuid',
        3 => 'setuid and sticky',
        4 => 'setgid',
        5 => 'setgid and sticky',
        6 => 'setuid and setgid',
        7 => 'sticky, setuid and setgid',
    );

    my $attributes = ($1 ? $1 : '');
    my $octal = $2;

    my @digits = split '', $2;

    my $symbolic = join '', map { $modes[$_] } @digits;

    if ($attributes ne '') {
        $octal = "$attributes$octal";
        $plain_output = "Attributes: $attributes{$1}\n";
        my $tmp_attributes = $attributes;
        my @symbolic = split '', $symbolic;
        if ($tmp_attributes >= 4) {
            $tmp_attributes -= 4;
            if ($symbolic[5] eq 'x') { $symbolic[5] = 's'; }
            else { $symbolic[5] = 'S'; }
        }
        if ($tmp_attributes >= 2) {
            $tmp_attributes -= 2;
            if ($symbolic[2] eq 'x') { $symbolic[2] = 's'; }
            else { $symbolic[2] = 'S'; }
        }
        if ($tmp_attributes >= 1) {
            $tmp_attributes -= 1;
            if ($symbolic[8] eq 'x') { $symbolic[2] = 't'; }
            else { $symbolic[8] = 'T'; }
        }
        $symbolic = join '', @symbolic;
    }

    $plain_output = "$symbolic (symbolic)\n" .
                    'User: '   . $modes_desc[$digits[0]] . "\n" .
                    'Group: '  . $modes_desc[$digits[1]] . "\n" .
                    'Others: ' . $modes_desc[$digits[2]] . "\n" .
                    ($plain_output ? $plain_output : '');

    $plain_output  = "$octal (octal)\n$plain_output";

    return $plain_output,
        structured_answer => {
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
                record_data => {
                    symbolic => $symbolic,
                    user => $modes_desc[$digits[0]],
                    group => $modes_desc[$digits[1]],
                    others => $modes_desc[$digits[2]],
                    attributes => $attributes{$attributes},
                },
                record_keys => ["symbolic", "user", "group", "others", "attributes"],
            },
            
        }
};

1;
