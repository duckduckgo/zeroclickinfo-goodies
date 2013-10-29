package DDG::Goodie::Dessert;

use DDG::Goodie;

sub itemify{
	my $i = rand scalar @_;
	return '<a href="http://duckduckgo.com/2/' . $_[$i] . '">' . $_[$i] . '</a> <a style="font-size: 10px;" href="http://duckduckgo.com/?q=' . $_[$i] . '+recipe">(recipes)</a>';
};

my %desserts = (
	a => ['Apple Turnover'],
	b => ['Banana Split', 'Biscuits'],
	c => ['Cherry Pie', 'Cupcake', 'Chocolate'],
	d => ['Donut'],
	e => ['Eclair'],
	f => ['Froyo', 'Fudge'],
	g => ['Gingerbread'],
	h => ['Honeycomb'],
	i => ['Ice Cream Sandwich', 'Ice Cream'],
	j => ['Jam Rolly Polly','Jelly Bean','Jelly'],
	k => ['Key Lime Pie'],
	l => ['Lollipop','Liqourice'],
	m => ['Macaroons','Meringues','Marshmallow','Muffin'],
	n => ['Nougat','Nutella'],
	o => ['Oatmeal Pie','Oreos'],
	p => ['Profiteroles','Pop Tart'],
	q => ['Quiche'],
	r => ['Rocky Road','Red Velvet Cake','Ruhbarb and Custard'],
	s => ['Sundae','Strudel','Strawberries and Cream','Souffle'],
	t => ['Tiramisu','Trifle','Twinkies','Taffy','Toffee'],
	u => ['Unicorn Cake','Upside-down cake'],
	v => ['Vanilla Swirl'],
	w => ['Waffles','Watermelon','White Chocolate'],
	x => ['Xmas Cake'],
	z => ['Zepolle','Zucchini Pie'],
);

triggers start => 'dessert', 'desserts';
handle remainder => sub{
    if(lc $_ =~ m/^(?:that )?(?:start|beginn?)s?(?:ing)? ?(?:with)? ([a-zA-Z])$/i){
	my $in = lc $1;
	my $output = 'A desert beginning with ' . (uc $in) . ' is ';
	
	my $items = $desserts{lc $in};
	$output .= itemify(@{$items});
	return $output;
    }
    return;
};

zci is_cached => 0;
1;
