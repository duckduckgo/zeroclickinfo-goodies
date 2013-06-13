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
      undef,
      html => qq(ACE (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.)
    ),
    'ace-230' => test_zci(
      undef,
      html => qq(ACE (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.)
    ),
    'jira random AJLIB-230 bug random' => test_zci(
      undef,
      html => qq(ajlib incubator (Codehaus JIRA Bugtracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.)
    ),
    'jira random ajlib-230 bug random' => test_zci(
      undef,
      html => qq(ajlib incubator (Codehaus JIRA Bugtracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.)
    ),
    'random debbug #638225 random' => test_zci(
      undef,
      html => qq(Debian bug tracker: see ticket <a href="http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=638225">#638225</a>.)
    ),
    'random debian bug #638225 random' => test_zci(
      undef,
      html => qq(Debian bug tracker: see ticket <a href="http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=638225">#638225</a>.)
    ),
    'random mozilla bug #638225 random' => test_zci(
      undef,
      html => qq(Mozilla bug tracker: see ticket <a href="https://bugzilla.mozilla.org/show_bug.cgi?id=638225">#638225</a>.)
    )
);

done_testing;
