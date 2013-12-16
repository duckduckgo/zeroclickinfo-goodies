package DDG::Goodie::BashPrimaryExpressions;

use DDG::Goodie;
use strict;
use warnings;

triggers start => 'bash if', 'bash';

primary_example_queries 'bash if statement';

description 'Bash Primary Expressions';
name 'Bash Help';
source 'http://tille.garrels.be/training/bash/ch07.html';
attribution github => [ 'http://github.com/mintsoft', 'mintsoft' ];

our %if_description = (
	'-a' => "True if ARG2 exists",
	'-b' => "True if ARG2 exists and is a block-special file",
	'-c' => "True if ARG2 exists and is a character-special file",
	'-d' => "True if ARG2 exists and is a directory",
	'-e' => "True if ARG2 exists",
	'-f' => "True if ARG2 exists and is a regular file",
	'-g' => "True if ARG2 exists and its SGID bit is set",
	'-h' => "True if ARG2 exists and is a symbolic link",
	'-k' => "True if ARG2 exists and its sticky bit is set",
	'-p' => "True if ARG2 exists and is a named pipe (FIFO)",
	'-r' => "True if ARG2 exists and is readable",
	'-s' => "True if ARG2 exists and has a size greater than zero",
	'-t' => "True if ARG2 descriptor FD is open and refers to a terminal",
	'-u' => "True if ARG2 exists and its SUID (set user ID) bit is set",
	'-w' => "True if ARG2 exists and is writable",
	'-x' => "True if ARG2 exists and is executable",
	'-O' => "True if ARG2 exists and is owned by the effective user ID",
	'-G' => "True if ARG2 exists and is owned by the effective group ID",
	'-L' => "True if ARG2 exists and is a symbolic link",
	'-N' => "True if ARG2 exists and has been modified since it was last read",
	'-S' => "True if ARG2 exists and is a socket",
	'-o' => "True if shell option ARG2 is enabled",
	'-z' => "True if the length of 'ARG2' is zero",
	'-n' => "True if the length of 'ARG2' is non-zero",
	'==' => "True if the strings ARG1 and ARG2 are equal",
	'!=' => "True if the strings ARG1 and ARG2 are not equal",
	'<' => "True if ARG1 string-sorts before ARG2 in the current locale",
	'>' => "True if ARG1 string-sorts after ARG2 in the current locale",
	'-eq' => "True if ARG1 and ARG2 are numerically equal",
	'-ne' => "True if ARG1 and ARG2 are not numerically equal",
	'-lt' => "True if ARG1 is numerically less than ARG2",
	'-le' => "True if ARG1 is numerically less than or equal to ARG2",
	'-gt' => "True if ARG1 is numerically greater than ARG2",
	'-ge' => ,"True if ARG1 is numerically greater than or euqal to ARG2"

);

handle remainder => sub {
	my ($not, $left_arg, $op, $right_arg) = ($_ =~ qr#^[\[]{1,2} ([!] )?(?:(.+?) )?(-[a-zA-Z]{1,2}|[<>]|[!=]{1,2}) (.+) [\]]{1,2}$#);	

	return unless ($op && $right_arg);
	return unless $if_description{$op};
	
	my $text_output = $if_description{$op};
	$text_output =~ s/ARG1/$left_arg/ if $left_arg;	
	$text_output =~ s/ARG2/$right_arg/;
	$text_output =~ s/^True/False/ if $not;
	return "$_ - $text_output";
};

1;