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
      html => qq(ACE (Apache JIRA bug tracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.)
    ),
    'ace-230' => test_zci(
      undef,
      html => qq(ACE (Apache JIRA bug tracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.)
    ),
    'jira random AJLIB-230 bug random' => test_zci(
      undef,
      html => qq(ajlib incubator (Codehaus JIRA bug tracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.)
    ),
    'jira random ajlib-230 bug random' => test_zci(
      undef,
      html => qq(ajlib incubator (Codehaus JIRA bug tracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.)
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
    ),
    'random Linux kernel #1234 random' => test_zci(
      undef,
      html => qq(Linux kernel bug tracker: see ticket <a href="https://bugzilla.kernel.org/show_bug.cgi?id=1234">#1234</a>.)
    ),
    'random jetty #234 random' => test_zci(
      undef,
      html => qq(jetty (Eclipse bug tracker): see ticket <a href="https://bugs.eclipse.org/bugs/show_bug.cgi?id=234">#234</a>.)
    ),
    'random bug LibreOffice #24 random' => test_zci(
      undef,
      html => qq(LibreOffice (LibreOffice bug tracker): see ticket <a href="https://www.libreoffice.org/bugzilla/show_bug.cgi?id=24">#24</a>.)
    )
);

done_testing;
