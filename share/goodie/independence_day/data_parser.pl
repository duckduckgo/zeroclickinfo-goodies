package MyParser;
use base qw(HTML::Parser);

my $column = 0;
my $field;
my $save_innertext;

sub text{
	my ($self, $origtext) = @_;
	if($field eq 'country'){
		print "\t\"$origtext\":{\n";
	}elsif($field eq 'date'){
		print "\t\t\"$field\": \"$origtext\",\n";
	}elsif($field eq 'year'){
		print "\t\t\"$field\": \"$origtext\"\n\t},\n";
	}
	$field = '';
}

sub start { 
    my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
    if ($tagname eq 'tr'){
    	$column = 0;
    }
    if ($tagname eq 'td') {
    	$column++;
    }
    if ($tagname eq 'a' && $column eq 1) {
    	$field = 'country';
    }
    # day and month
    if ($tagname eq 'span' && $attr->{ class } eq 'sorttext' && $column eq 2){
    	$field = 'date';
    }
    if ($tagname eq 'td' && $column eq 3){
    	$field = 'year';
    }
}

package main;


my $file = "wikipedia_html_table";
my $parser = MyParser->new;
print "{\n";
$parser->parse_file( $file );	# parse() is also inherited from HTML::Parser
print "}\n";


