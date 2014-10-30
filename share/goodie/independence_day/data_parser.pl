package MyParser;
use base qw(HTML::Parser);
# ABSTRACT: Parses specific data from html table on wikipedia into json
# uses the the table from https://en.wikipedia.org/wiki/List_of_national_independence_days
# as data source

# parser state information
my $column = 0;
my $field;

# prints out relevant data (as json)
sub text{
    my ($self, $origtext) = @_;
    if($field eq 'country'){
        # lowercase country names
        $origtext = lc($origtext);
        $origtext =~ s/(.*), (.*)/$2 $1/;
        print "\t'$origtext' => [{";
    }elsif($field eq 'date'){
        # replace html entities with regular space
        $origtext =~ s/&#160;/ /g;
        # add proper suffix to day number
        $origtext =~ s/ 1$/ 1st/;
        $origtext =~ s/ 2$/ 2nd/;
        $origtext =~ s/ 3$/ 3rd/;
        $origtext =~ s/( [0987654321]+)$/$1th/;

        print "$field => \"$origtext\", ";
    }elsif($field eq 'year'){
        print "$field => \"$origtext\"}],\n";
    }
    # make sure we dont print unintended data form subsequent fields
    $field = '';
}

# triggered when parser encouters tag start
sub start { 
    my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
    # stated parsing new table row
    if ($tagname eq 'tr'){
        $column = 0;
    }
    # parser reached next column
    if ($tagname eq 'td') {
        $column++;
    }
    # country names are inside link tags in the first column
    if ($tagname eq 'a' && $column eq 1) {
        $field = 'country';
    }
    # dates are inside span with class 'sorttext' in column 2
    elsif ($tagname eq 'span' && $attr->{ class } eq 'sorttext' && $column eq 2){
        $field = 'date';
    }
    # years are just plain in the 3rd column
    elsif ($tagname eq 'td' && $column eq 3){
        $field = 'year';
    }
}

package main;


my $file = "wikipedia_html_table";
my $parser = MyParser->new;
print "my \%data = (\n";
$parser->parse_file( $file );
print ");\n";


