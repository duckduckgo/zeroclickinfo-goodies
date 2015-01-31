package DDG::Goodie::KernelTaint;
# ABSTRACT: Parses and explains the OR'd values of /proc/sys/kernel/tainted

use DDG::Goodie;

primary_example_queries 'kernel taint 5121', 'kernel taint description 2';
description 'Parses and explains the OR\'d values of /proc/sys/kernel/tainted';
name 'KernelTaint';
source 'https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/sysctl/kernel.txt';
code_url 'https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/KernelTaint.pm';
category 'computing_tools';
topics 'computing', 'sysadmin', 'special_interest';
attribution github => ['http://github.com/nospampleasemam', 'Dylan Lloyd'],
               web => ['http://dylansserver.com/', 'Dylan Lloyd'];

zci answer_type => 'kernel_taint';
zci is_cached   => 1;

triggers any => 'kernel taint', 'linux taint', 'linux kernel taint', 'taint kernel' , 'taint linux', 'taint linux kernel', '/proc/sys/kernel/tainted', 'proc sys kernel tainted';

my %descriptions = (
    1    => 'A module with a non-GPL license has been loaded, this includes modules with no license. Set by modutils >= 2.4.9 and module-init-tools.',
    2    => 'A module was force loaded by insmod -f. Set by modutils >= 2.4.9 and module-init-tools.',
    4    => 'Unsafe SMP processors: SMP with CPUs not designed for SMP.',
    8    => 'A module was forcibly unloaded from the system by rmmod -f.',
    16   => 'A hardware machine check error occurred on the system.',
    32   => 'A bad page was discovered on the system.',
    64   => 'The user has asked that the system be marked "tainted".  This could be because they are running software that directly modifies the hardware, or for other reasons.',
    128  => 'The system has died.',
    256  => 'The ACPI DSDT has been overridden with one supplied by the user instead of using the one provided by the hardware.',
    512  => 'A kernel warning has occurred.',
    1024 => 'A module from drivers/staging was loaded.',
    2048 => 'The system is working around a severe firmware bug.',
    4096 => 'An out-of-tree module has been loaded.',
);

handle remainder => sub {

    s/description|error|\s+//g;

	return unless /^\d+$/;

    my $mask = shift;

    my @taints = grep { $_ } map {
        $mask & 1<<$_ ? "$descriptions{2**$_}" : '';
    } (0..(scalar keys %descriptions)-1);

    return join("\n", map { "- $_" } @taints), html => '<ul>' . join('', map { "<li>$_</li>" } @taints). '</ul>'
        . '<a href="https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/sysctl/kernel.txt">Read more</a>';
};

1;
