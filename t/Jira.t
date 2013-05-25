#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'jira';
zci is_cached => 1;

ddg_goodie_test(

    [qw( DDG::Goodie::Jira)],
    'ACE-230' => test_zci(
     "ACE-230",
     heading => 'JIRA Bugtracker',
     html => qq(ACE on Apache JIRA Bugtracker: see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.<br>)
    ),
    'jira ACE-230' => test_zci(
     "ACE-230",
     heading => 'JIRA Bugtracker',
     html => qq(ACE on Apache JIRA Bugtracker: see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.<br>)
    ),
    'ACE-230 bug' => test_zci(
     "ACE-230",
     heading => 'JIRA Bugtracker',
     html => qq(ACE on Apache JIRA Bugtracker: see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.<br>)
    ),
    'jira ACE-230 bug' => test_zci(
     "ACE-230",
     heading => 'JIRA Bugtracker',
     html => qq(ACE on Apache JIRA Bugtracker: see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.<br>)
    )
);

done_testing;
