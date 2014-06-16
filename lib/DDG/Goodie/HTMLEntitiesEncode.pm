package DDG::Goodie::HTMLEntitiesEncode;
# ABSTRACT: Displays the HTML entity code for the query name.

use DDG::Goodie;
use HTML::Entities qw(encode_entities);
use warnings;
use strict;

# '&' and ';' not included in the hash value -- they are added in make_text and make_html
my %codes = (
	# Punctuation
	'en dash' => [['En dash', 'ndash']],
	'em dash' => [['Em dash', 'mdash']],
	'hyphen' => [['Hyphen', '#8208']],
	'soft hyphen' => [['Soft hyphen', '#173']],

	'inverted question mark' => [['Inverted question mark', 'iquest']],
	'inverted exclamation' => [['Inverted exclamation', 'iexcl']],
	'inverted exclamation point' => [['Inverted exclamation', 'iexcl']],
	'inverted exclamation mark' => [['Inverted exclamation', 'iexcl']],
	'backward semicolon' => [['Backward semicolon','#8271']],

	'quotation mark' => [['Double quotation mark', 'quot']],
	'double quote' => [['Double quotation mark', 'quot']],
	'left double quote' => [['Left double curly quote','ldquo']],
	'left double curly quote' => [['Left double curly quote','ldquo']],
	'right double quote' => [['Right double curly quote','rdquo']],
	'right double curly quote' => [['Right double curly quote','rdquo']],
	'double curly quote' => [['Left double curly quote','ldquo'],['Right double curly quote','rdquo']],

	'apostrophe' => [['Apostrophe','#39']],
	'single quote' => [['Single quote','#39']],
	'left single quote' => [['Left single curly quote','lsquo']],
	'left single curly quote' => [['Left single curly quote','lsquo']],
	'right single quote' => [['Right single curly quote','rsquo']],
	'right single curly quote' => [['Right single curly quote','rsquo']],
	'single curly quote' => [['Left single curly quote','lsquo'],['Right single curly quote','rsquo']],

	'angle quote' => [['Single left pointing angle quote', 'lsaquo'],['Single right pointing angle quote', 'rsaquo'],['Double left pointing angle quote','laquo'],['Double right pointing angle quote','raquo']],
	'angle bracket' => [['Single left pointing angle quote', 'lsaquo'],['Single right pointing angle quote', 'rsaquo'],['Double left pointing angle quote','laquo'],['Double right pointing angle quote','raquo']],
	'guillemets' => [['Single left pointing angle quote', 'lsaquo'],['Single right pointing angle quote', 'rsaquo'],['Double left pointing angle quote','laquo'],['Double right pointing angle quote','raquo']],

	'left angle quote' => [['Single left pointing angle quote', 'lsaquo'],['Double left pointing angle quote','laquo']],
	'left angle bracket' => [['Single left pointing angle quote', 'lsaquo'],['Double left pointing angle quote','laquo']],
	'right angle quote' => [['Single right pointing angle quote', 'rsaquo'],['Double right pointing angle quote','raquo']],
	'right angle bracket' => [['Single right pointing angle quote', 'rsaquo'],['Double right pointing angle quote','raquo']],

	'space' => [['Non-breaking space','nbsp']],
	'invisible comma' => [['Invisible comma','#8291']],

	# Symbols
	'ampersand' => [['Ampersand','amp']],
	'copyright' => [['Copyright', '#169']],
	'recording copyright' => [['Recording copyright','#8471']],
	'registered' => [['Registered', '#174']],
	'trademark' => [['Trademark','#8482']],
	'rx' => [['Prescription sign','#8478']],
	'prescription' => [['Prescription sign','#8478']],
	'numero' => [['Numero sign', '#8470']],
	'hash' => [['Number sign','#35']], # same as number sign (below)
	'number' => [['Number sign','#35']], # same as hash (above)
	'backslash' => [['Backslash','#92']],
	'hat' => [['Hat', '#94']], # x-post with caret
	'broken vertical bar' => [['Broken vertical bar','brvbar']],
	'pipe' => [['Pipe', '#8214']],
	'dagger' => [['Dagger','dagger']],

	# Special/misc.
	'macron' => [['Macron', '#175']],
	'diaeresis' => [['Diaeresis','#168']],
	'female' => [['Female sign', '#9792']],
	'male' => [['Male sign','#9794']],
	'phone' => [['Phone sign','#9742']],
	'checkmark' => [['Checkmark','#10003']],
	'cross' => [['Cross (straight)', '#10799'],['Cross (slanted)','#10007']],
	'caret' => [['Caret','#8257'],['Hat', '#94']],

	# Arrows
	'up arrow' => [['Up arrow','#8593']],
	'down arrow' => [['Down arrow','#8595']],
	'left arrow' => [['Left arrow','#8592']],
	'right arrow' => [['Right arrow', '#8594']],
	'up down arrow' => [['Up-down arrow', '#8597']],
	'left right arrow' => [['Left-right arrow', '#8596']],
	'double sided arrow' => [['Up-down arrow', '#8597'],['Left-right arrow', '#8596']],
	'two sided arrow' => [['Up-down arrow', '#8597'],['Left-right arrow', '#8596']],

	# Currency
	'cent' => [['Cent','cent']],
	'dollar' => [['Dollar sign','#36']],
	'peso' => [['Peso','#36']],
	'yen' => [['Yen', 'yen']],
	'japanese yen' => [['Yen', 'yen']],
	'euro' => [['Euro','euro']],
	'currency' => [['Currency sign','curren']],
	'british pound' => [['British Pound Sterling','pound']],
	'british pound sterling' => [['British Pound Sterling','pound']],
	'pound' => [['British Pound Sterling','pound'],['Number sign','#35']], # x-post with number sign

	# Math
	'divide' => [['Divide','#247']],
	'greater than' => [['Greater than','gt']],
	'less than' => [['Less than','lt']],
	'greater than or equal to' => [['Greater than or equal to','#8805']],
	'less than or equal to' => [['Less than or equal to','#8804']],
	'nested greater than' => [['Nested greater than','#8811']],
	'nested less than' => [['Nested less than','#8810']],
	'plus minus' => [['Plus/minus','#177']],
	'plus/minus' => [['Plus/minus','#177']],
	'+-' => => [['Plus/minus','#177']],
	'percent' => [['Percent sign','#37']],
	'percentage' => [['Percent sign','#37']],
	'per mil' => [['Per mil','permil']],
	'per mille' => [['Per mil','permil']],
	'per ten thousand' => [['Per ten thousand','#8241']],
	'degree' => [['Degree sign','#176']],
	'perpendicular' => [['Perpendicular', '#8869']],
	'parallel' => [['Parallel', '#8741']],
	'non parallel' => [['Non parallel', '#8742']],
	'integral' => [['Integral','#8747']],
	'double integral' => [['Double integral','#8748']],
	'triple integral' => [['Triple integral','#8749']],
	'path integral' => [['Path integral','#8750']], # same as path integral (below)
	'contour integral' => [['Contour integral','#8750']], # same as contour integral (above)
	'therefore' => [['Therefore (mathematics)','#8756']],
	'infinity' => [['Infinity','infin']],
	'radical' => [['Radical sign','#8730']],
	'square root' => [['Square root','#8730']],
	'not equal' => [['Not equal','#8800']],
	'equivalent' => [['Equivalent','#8801']], # same entity as congruent (below)
	'congruent' => [['Congruent','#8801']], # same entity as equivalent (above)
	'not equivalent' => [['Not equivalent','#8802']],
	'not congruent' => [['Not congruent','#8802']],
	'sum' => [['Summation (mathematics)','#8721']],
	'summation' => [['Summation (mathematics)','#8721']],
	'pi' => [['Pi','#960']],
	'reals' => [['Reals (mathematics)','#8477']],
	'complexes' => [['Complexes','#8450']],
	'imaginary' => [['Imaginary (mathematics)','#8520']],

	# Scientific
	'micro' => [['Micro', '#181']],
	'ohm' => [['Ohm','#8486']],
	'mho' => [['Mho','#8487']],

	# Typography
	'middle dot' => [['Middle dot', 'middot']],
	'pilcrow' => [['Pilcrow', '#182']],
	'paragraph' => [['Paragraph sign', '#182']],
	'section' => [['Section', '#167']],
	'section s' => [['Section', '#167']],
	'ellipsis' => [['Horizontal ellipsis','#8230']],
	'horizontal ellipsis' => [['Horizontal ellipsis','#8230']],

	# Accents -- also see the hash accented_chars
	'grave' => [['Grave accent','#96']],
	'grave accent' => [['Grave accent','#96']],
	'acute' => [['Acute accent','#180']],
	'acute accent' => [['Acute accent','#180']],

	# Greek
	'alpha' => [['Alpha capital','Alpha'],['Alpha small','alpha']],
	'beta' => [['Beta capital','Beta'],['Beta small','beta']],
	'gamma' => [['Gamma capital','Gamma'],['Gamma small','gamma']],
	'phi' => [['Phi capital','Phi'],['Phi small','phi']],
	'omega' => [['Omega capital','Omega'],['Omega small','omega']],
	'kappa' => [['Kappa capital','Kappa'],['Kappa small','kappa']],
	'delta' => [['Delta capital','Delta'],['Delta small','delta']], # also displays a HTML Color Codes Goodie answer

	# Shapes
	'trapezium' => [['Trapezium', '#9186']],
	'parallelogram' => [['Parallelogram', '#9649']],
	'spade' => [['Spade (suit)','#9824']],
	'club' => [['Club (suit)','#9827']],
	'heart' => [['Heart (suit)','#9829']],
	'diamond' => [['Diamond (shape)','#8900'],['Diamond (suit)','#9830']],
);

my %accented_chars = (
	'agrave' => [['a-grave','agrave']],
	'Agrave' => [['A-grave','Agrave']],
	'egrave' => [['e-grave','egrave']],
	'Egrave' => [['E-grave','Egrave']],
	'igrave' => [['i-grave','igrave']],
	'Igrave' => [['I-grave','Igrave']],
	'ograve' => [['o-grave','ograve']],
	'Ograve' => [['O-grave','Ograve']],
	'ugrave' => [['u-grave','igrave']],
	'Ugrave' => [['U-grave','Ugrave']],

	'aacute' => [['a-acute','aacute']],
	'Aacute' => [['A-acute','Aacute']],
	'eacute' => [['e-acute','eacute']],
	'Eacute' => [['E-acute','Eacute']],
	'iacute' => [['i-acute','iacute']],
	'Iacute' => [['I-acute','Iacute']],
	'oacute' => [['o-acute','oacute']],
	'Oacute' => [['O-acute','Oacute']],
	'uacute' => [['u-acute','iacute']],
	'Uacute' => [['U-acute','Uacute']],
);

triggers startend => 'html code', 'html entity', 'html character code', 'html encode', 'encode html', 'htmlencode', 'encodehtml', 'html escape', 'htmlescape', 'escape html', 'escapehtml';
primary_example_queries 'html code em dash', 'html entity A-acute', 'html encode &';
secondary_example_queries 'html code em-dash', 'html entity for E grave', 'html entity $', 'html encode pound sign', 'html character code for trademark symbol';
name 'HTMLEntitiesEncode';
description 'Displays the HTML entity code for the query name';
category 'cheat_sheets';
topics 'programming', 'web_design';
attribution web => ["http://nishanths.github.io", "Nishanth Shanmugham"],
    		github => [ "https://github.com/nishanths", "Nishanth Shanmugham"],
    		twitter => ["https://twitter.com/nshanmugham", "Nishanth Shanmugham"],
    		twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/HTMLEntitiesEncode.pm";
zci answer_type => 'html_entity';

my $url = "http://dev.w3.org/html5/html-author/charref";

sub make_text {
	# Returns a text string containing the HTML character name and entity
	my $text = "";
	foreach my $i (0 .. scalar(@{$_[0]}) - 1) {
		$text = $i ? ("$text" . "\n" . "$_[0][$i][0]: &$_[0][$i][1];") : ("$text" . "$_[0][$i][0]: &$_[0][$i][1];"); # No \n in the first line of the answer
	}
	return $text;
};

sub make_html {
	# Returns a html formatted string containing the HTML character name, entity, and a link
	my $html = "";
	if (scalar(@{$_[0]}) == 1) { # single line answer
		$html = "<div>$_[0][0][0] (&$_[0][0][1];): &<span>$_[0][0][1]</span>;&nbsp;&nbsp;<a href=\"$url\">More at W3</a></div>" ; # link in the same line for single line answers
	} else {
		foreach my $i (0 .. scalar(@{$_[0]}) - 1) { # multiple line answer
			$html = "$html" . "<div>$_[0][$i][0] (&$_[0][$i][1];): &<span>$_[0][$i][1]</span>;</div>";
		}
		$html = "$html" . "<div><a href=\"$url\">More at W3</a></div>";
	}	
	return $html;
};

handle remainder => sub {
	my $key;
	my $value;

	$_ =~ s/^\s*//; # remove front whitespace
	$_ =~ s/\s*$//; # remove back whitespace.

	# HASHES LOOKUP
	my $hashes_query = $_;
	$hashes_query =~ s/^(for|of)\s+//g; # remove filler words at the start
	$hashes_query =~ s/\s+(symbol|sign)//g; # remove 'symbol' and 'sign'
	
	$hashes_query =~ s/\-/ /; # change '-' to ' '
	$hashes_query =~ s/"//; # remove double quote
	$hashes_query =~ s/'//; # remove single quote
	# If a string still exists after the stripping, lookup the accented_chars hash if it's an accented character query and if it's not an accented char look up the codes hash
	if ($hashes_query) {
		if ($hashes_query =~ /^(a|A|e|E|i|I|o|O|u|U)\s*(grave|acute)$/) { # search query is for an accented character
			$hashes_query =~ s/\s*//g; # remove in between spaces
			$key = $hashes_query; # capitalization matters for accented characters lookup
			$value = $accented_chars{$key};
		} else { # not an accented char -- so lookup codes hash
			$key = lc $hashes_query;
			$value = $codes{$key};
		}
		# If a we found a value in the hashes, we have a positive hit. Return.
		if (defined $value) {
			my $text = make_text($value);
			my $html = make_html($value);
			return $text, html => $html;
		}
	}

	# SINGLE CHARACTER ENCODING
	# If we have gotten this far, there were no hits above
	# Use the encode function of HTML::Entities
	if (length($_) == 1){
		my $entity = encode_entities($_);
	    if ($entity eq $_) { # encode_entities returns the same if it fails
	    	$entity = ord($_); # get the decimal
	    	$entity = '#' . $entity; # dress it up like a decimal
	    }
	    $entity =~ s/^&//;
	    $entity =~ s/;$//;
	    my $text = "Encoded HTML Entity: &$entity;";
	    my $html = "<div>Encoded HTML Entity (&$entity;): &<span>$entity</span>;&nbsp;&nbsp;<a href=\"$url\">More at W3</a></div>";
	    return $text, html => $html;
	}

	return;
};

1;
