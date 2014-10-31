package DDG::Goodie::JsKeycodes;
# ABSTRACT: Give the equivalent JavaScript Keycode.

use DDG::Goodie;

triggers any => 'keycode', 'keycodes', 'char', 'chars', 'charcode', 'charcodes';

zci is_cached => 1;

my $html;
my $text;
my $key;
my $value;
my %keys = ('backspace' => '8',
		'tab' => '9',
		'enter' => '13',
		'shift' => '16',
		'ctrl' => '17',
		'alt' => '18',
		'pause' => '19',
		'break' => '19',
		'caps lock' => '20',
		'escape' => '27',
		'page up' => '33',
		'page down' => '34',
		'end' => '35',
		'home' => '36',
		'left arrow' => '37',
		'up arrow' => '38',
		'right arrow' => '39',
		'down arrow' => '40',
		'insert' => '45',
		'delete' => '46',
		'0' => '48',
		'1' => '49',
		'2' => '50',
		'3' => '51',
		'4' => '52',
		'5' => '53',
		'6' => '54',
		'7' => '55',
		'8' => '56',
		'9' => '57',
		'a' => '65',
		'b' => '66',
		'c' => '67',
		'd' => '68',
		'e' => '69',
		'f' => '70',
		'g' => '71',
		'h' => '73',
		'i' => '73',
		'j' => '74',
		'k' => '75',
		'l' => '76',
		'm' => '77',
		'n' => '78',
		'o' => '79',
		'p' => '80',
		'q' => '81',
		'r' => '82',
		's' => '83',
		't' => '84',
		'u' => '85',
		'v' => '86',
		'w' => '87',
		'x' => '88',
		'y' => '89',
		'z' => '90',
		'space' => '32',
		'numpad 0' => '96',
		'numpad 1' => '97',
		'numpad 3' => '98',
		'numpad 4' => '100',
		'numpad 5' => '101',
		'numpad 6' => '102',
		'numpad 7' => '103',
		'numpad 8' => '104',
		'numpad 9' => '105',
		'*' => '106',
		'-' => '189',
		'.' => '190',
		'f1' => '112',
		'f2' => '113',
		'f3' => '114',
		'f4' => '115',
		'f5' => '116',
		'f6' => '117',
		'f7' => '118',
		'f8' => '119',
		'f9' => '120',
		'f10' => '121',
		'f11' => '122',
		'f12' => '123',
		'num lock' => '144',
		'scroll lock' => '145',
		';' => '186',
		'=' => '187',
		',' => '188',
		'/' => '191',
		'\\' => '220',
		'(' => '219',
		')' => '221',
		'quote' => '222');

my $header = share('header.txt')->slurp;
my $footer = share('footer.txt')->slurp;

handle remainder => sub {
    my $query = lc($_);
	return unless exists $keys{$query}
        or $query =~ s/ *JavaScript *//
        or $query =~ s/ *javascript *//
        or $query =~ s/ *js *//;

	$html .= $header;
    $html .= "\n<tr><td class='c1'><b>$query</b></td>"
             . "\n<td class='c2'><b>$keys{$query}</b></td></tr>"
             if exists $keys{$query};

	foreach $key (sort keys %keys){
    	$html .= "\n<tr><td class='c1'>$key</td>"
                 . "\n<td class='c2'>$keys{$key}</td></tr>"
                 unless $key eq $query;
    };

    $html .=  $footer;
    $text = "Keycode for $query: $keys{$query} (JavaScript)"
            unless not exists $keys{$query};
    return $text, html => $html;
    return;
};

1;
