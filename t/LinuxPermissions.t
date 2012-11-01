#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'linux_permissions';
zci is_cached => 1;

ddg_goodie_test(
   [qw(
       DDG::Goodie::LinuxPermissions
   )],
   '0644' => test_zci('User: Read and Write
Group: Read
Others: Read

rw-r--r--'),
   '0777' => test_zci('User: Read, Write, and Execute
Group: Read, Write, and Execute
Others: Read, Write, and Execute

rwxrwxrwx')
);

done_testing;
