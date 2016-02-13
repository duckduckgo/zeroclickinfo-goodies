#!/usr/local/bin/perl
#
# Anagram Generator
#

use utf8;
use JSON::XS qw(encode_json decode_json);
use File::Slurp qw(read_file write_file);

# open file
open(FILE, "/usr/share/dict/words") or die("Unable to open file");

# read file into an array
my %dict = ();

while (my $line = <FILE>) {
    chomp $line;

# get last two letters of word. the unix words file has man duplicated possessive words with the 's appended which do not serve our purpose for anagram finding.
    $amt = substr($line, -2);

    unless ($amt eq '\'s'){

	$lcline = lc($line);

	## Spliting the string with no delimeter.
	$sorted_string = join("",sort(split("",$lcline)));

	if (exists $dict{$sorted_string}) {
	    push @{$dict{$sorted_string}}, $line;
	}
	else {
	    push @{$dict{$sorted_string}}, $line;
	}
    }
}

# close file
close(FILE);

my $json = encode_json \%dict;
write_file('words.json', { binmode => ':raw' }, $json);
