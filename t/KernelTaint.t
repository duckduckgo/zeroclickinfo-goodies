#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'kernel_taint';
zci is_cached   => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::KernelTaint
	)],
	'kernel taint 5121' => test_zci('- A module with a non-GPL license has been loaded, this includes modules with no license. Set by modutils >= 2.4.9 and module-init-tools.
- A module from drivers/staging was loaded.
- An out-of-tree module has been loaded.', html => '<ul><li>A module with a non-GPL license has been loaded, this includes modules with no license. Set by modutils >= 2.4.9 and module-init-tools.</li><li>A module from drivers/staging was loaded.</li><li>An out-of-tree module has been loaded.</li></ul><a href="https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/sysctl/kernel.txt">Read more</a>'),
	'error description /proc/sys/kernel/tainted 2' => test_zci('- A module was force loaded by insmod -f. Set by modutils >= 2.4.9 and module-init-tools.', html => '<ul><li>A module was force loaded by insmod -f. Set by modutils >= 2.4.9 and module-init-tools.</li></ul><a href="https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/sysctl/kernel.txt">Read more</a>'),
	'2 kernel taint description' => test_zci('- A module was force loaded by insmod -f. Set by modutils >= 2.4.9 and module-init-tools.', html => '<ul><li>A module was force loaded by insmod -f. Set by modutils >= 2.4.9 and module-init-tools.</li></ul><a href="https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/sysctl/kernel.txt">Read more</a>')
);

done_testing;
