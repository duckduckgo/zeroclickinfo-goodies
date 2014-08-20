package DDG::Goodie::HTMLEntitiesEncode;
# ABSTRACT: Displays the HTML entity code for the query name.

use DDG::Goodie;
use strict;
use warnings;

# '&' and ';' not included in the hash value -- they are added in make_text() and make_html()
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
    'registered' => [['Registered trademark', '#174']],
    'registered trademark' => [['Registered', '#174']],
    'trademark' => [['Trademark','#8482']],
    'rx' => [['Prescription sign','#8478']],
    'prescription' => [['Prescription sign','#8478']],
    'numero' => [['Numero sign', '#8470']],
    'hash' => [['Number sign','#35']], # same as number sign (below)
    'number' => [['Number sign','#35']], # same as hash (above)
    'forward slash' => [['Forward slash','#47']],
    'slash' => [['Forward slash','#47']],
    'backslash' => [['Backslash','#92']],
    'back slash' => [['Backslash','#92']],
    'hat' => [['Hat', '#94']], # x-post with caret
    'broken vertical bar' => [['Broken vertical bar','brvbar']],
    'pipe' => [['Pipe', '#8214']],
    'pipes' => [['Pipe', '#8214']],
    'dagger' => [['Dagger','dagger']],
    'bullet' => [['Bullet','#8226']],

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
    'dollar' => [['Dollar','#36']],
    'us dollar' => [['Dollar','#36']],
    'peso' => [['Peso','#36']],
    'yen' => [['Yen', 'yen']],
    'japanese yen' => [['Yen', 'yen']],
    'euro' => [['Euro','euro']],
    'currency' => [['Currency sign','curren']],
    'british pound' => [['British Pound Sterling','pound']],
    'british pound sterling' => [['British Pound Sterling','pound']],
    'pound' => [['British Pound Sterling','pound'],['Number sign','#35']], # x-post with number sign, hash

    # Math
    'divide' => [['Divide','#247']],
    'division' => [['Divide','#247']],
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

    # Accents -- also see the hash %accented_chars
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
    'delta' => [['Delta capital','Delta'],['Delta small','delta']], # also displays a HTML Color Codes Goodie answer - Issue #490

    # Shapes
    'trapezium' => [['Trapezium', '#9186']],
    'parallelogram' => [['Parallelogram', '#9649']],
    'spade' => [['Spade (suit)','#9824']],
    'club' => [['Club (suit)','#9827']],
    'heart' => [['Heart (suit)','#9829']],
    'diamond' => [['Diamond (suit)','#9830']],
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
    'ugrave' => [['u-grave','ugrave']],
    'Ugrave' => [['U-grave','Ugrave']],

    'aacute' => [['a-acute','aacute']],
    'Aacute' => [['A-acute','Aacute']],
    'eacute' => [['e-acute','eacute']],
    'Eacute' => [['E-acute','Eacute']],
    'iacute' => [['i-acute','iacute']],
    'Iacute' => [['I-acute','Iacute']],
    'oacute' => [['o-acute','oacute']],
    'Oacute' => [['O-acute','Oacute']],
    'uacute' => [['u-acute','uacute']],
    'Uacute' => [['U-acute','Uacute']],
);

my $css = share("style.css")->slurp();
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
};

sub make_text {
    # Returns a text string of the form: "Encoded HTML Entity: <<entity>>"
    my $text = "";
    foreach my $i (0 .. scalar(@{$_[0]}) - 1) {
        $text = $i ? ("$text" . "\n" . "Encoded HTML Entity: &$_[0][$i][1];") : ("$text" . "Encoded HTML Entity: &$_[0][$i][1];"); # No \n in the first line of the answer
    }
    return $text;
};

sub make_html {
    # Returns a html formatted string with css class names (no inline styles)
    my $html;
    if (scalar(@{$_[0]}) == 1) { # single line answer
        $html = qq(<div class="zci--htmlentitiesencode"><span class="text--secondary">Encoded HTML Entity (&$_[0][0][1];): </span><span class="text--primary">&<span>$_[0][0][1]</span>;</span></div>) ; # link in the same line for single line answers
    } else {
        $html = qq(<div class="zci--htmlentitiesencode">);
        foreach my $i (0 .. scalar(@{$_[0]}) - 1) { # multiple line answer
            $html = $html . qq(<div><span class="text--secondary">$_[0][$i][0] (&$_[0][$i][1];): </span><span class="text--primary">&<span>$_[0][$i][1]</span>;</span></div>);
        }
        $html = $html . "</div>";
    }
    return $html;
};

triggers any =>             'html', 'entity', 'htmlencode','encodehtml','htmlescape','escapehtml', 'htmlentity';

primary_example_queries     'html em dash', 'html entity A-acute', 'html escape &';
secondary_example_queries   'html code em-dash', 'html entity for E grave', '$ sign htmlentity', 'pound sign html encode', 'html character code for trademark symbol',
                            'what is the html entity for greater than sign', 'how to encode an apostrophe in html';

name                        'HTMLEntitiesEncode';
description                 'Displays the HTML entity code for the query name';
category                    'cheat_sheets';
topics                      'programming', 'web_design';
code_url                    'https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/HTMLEntitiesEncode.pm';
zci answer_type =>          'html_entity';

attribution web     =>      ["http://nishanths.github.io", "Nishanth Shanmugham"],
            github  =>      ["https://github.com/nishanths", "Nishanth Shanmugham"],
            twitter =>      ["https://twitter.com/nshanmugham", "Nishanth Shanmugham"],
            twitter =>      'crazedpsyc',
            cpan    =>      'CRZEDPSYC' ;

handle remainder => sub {
    # General query cleanup
    $_ =~ s/^\s+|\s+$//g; # remove front and back whitespace
    $_ =~ s/(\bwhat\s*is\s*(the)?)//ig; # remove "what is the" (optional: the)
    $_ =~ s/(\bhow\s*do\s*(i|you|we))//ig; # remove "how do i|you|we"
    $_ =~ s/(\bhow\s*to)//ig; # remove "how to"
    $_ =~ s/\b(an|the|for|of|in|is|sign|symbol|character|code|encode|encoded|entity|escape|put|embed|get|insert|display|my|(a(?![\s\-*](grave|acute))))\b//ig; # remove filler words (the word boundary anchors ensure 'for' is not removed from "formula")
    $_ =~ s/^\s+|\s+$//g; # remove front and back whitespace that existed in between that may now show up after removing the words above

    # Hash-specific query cleanup for better hits
    my $hashes_query = $_;
    $hashes_query =~ s/\-+/ /g; # change '-' to ' '
    $hashes_query =~ s/"|'//g; # remove double and single quotes
    $hashes_query =~ s/\s*\?$//g; # remove ending question mark
    # Hashes lookup
    if ($hashes_query) {
        my $key;
        my $value;
        # Query is for accented character
        if ($hashes_query =~ /^([a-zA-Z])\s*(grave|acute)$/i) {
            $hashes_query = $1 . lc $2; # $1's capitalization matters for accented characters lookup, lc $2 allows for more freedom in queries
            $key = $hashes_query;
            $value = $accented_chars{$key};
        # Not an accented character -- lookup the $codes hash instead
        } else { 
            $key = lc $hashes_query;
            $value = $codes{$key};
        }
        # Try again after substitutions if there is no hit
        unless (defined $value) {
            $key =~ s/brackets/bracket/g;
            $key =~ s/quotes/quote/g;
            $value = $codes{$key};
        }
        # Make final answer
        if (defined $value) {
            my $text = make_text($value);
            my $html = make_html($value);
            $html = append_css($html);
            return $text, html => $html;
        }
    }

    # Query maybe a single typed-in character to encode
    # No hits above if we got this far, use html_enc()
    if (   (/^(?:")(?<char>.)(?:")\s*\??$/)     # a (captured) single character within double quotes
        || (/^(?:'')(?<char>.)(?:'')\s*\??$/)   # or within single quotes
        || (/^(?<char>.)\s*\??$/)) {            # or stand-alone
        my $entity = html_enc($+{char});
        if ($entity eq $+{char}) { # html_enc() was unsuccessful and returned the input itself
            $entity = ord($+{char}); # get the decimal
            $entity = '#' . $entity; # dress it up like a decimal
        }
        # Remove '&' and ';' from the output of html_enc(), these will be added in html
        $entity =~ s/^&//g; 
        $entity =~ s/;$//g;
        # Make final answer
        my $answer = [[$_, $entity]];
        my $text = make_text($answer);
        my $html = make_html($answer);
        $html = append_css($html);
        return $text, html => $html;
    }

    return;
};

1;
