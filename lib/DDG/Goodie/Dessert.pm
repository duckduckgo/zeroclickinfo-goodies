package DDG::Goodie::Dessert;

use DDG::Goodie;

sub itemify{
	my $i = rand scalar @_;
	my $dessert = $_[$i];
	$dessert =~ s/\s/+/g;

	return "<a href='http://duckduckgo.com/?q=$dessert+recipe'>$_[$i]</a>";
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

triggers start => 'dessert', 'desserts', 'a dessert';
handle remainder => sub{
    if(lc $_ =~ m/^(?:that )?(?:start|beginn?)s?(?:ing)? ?(?:with)? (?:the letter )?([a-zA-Z])$/i){
	my $in = lc $1;
	my $items = $desserts{lc $in};

	my $output = itemify(@{$items}) . " is a dessert that begins with the letter " . uc $in . '.';
	return $output;
    }
    return;
};

zci is_cached => 0;
1;
