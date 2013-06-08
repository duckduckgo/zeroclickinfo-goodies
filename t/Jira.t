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
      '',
      html => qq(ACE (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.<br>)
    ),
    'ace-230' => test_zci(
      '',
      html => qq(ACE (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.<br>)
    ),
    'jira random AJLIB-230 bug random' => test_zci(
      '',
      html => qq(ajlib incubator (Codehaus JIRA Bugtracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.)
    ),
    'jira random ajlib-230 bug random' => test_zci(
      '',
      html => qq(ajlib incubator (Codehaus JIRA Bugtracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.)
    )
);

done_testing;
