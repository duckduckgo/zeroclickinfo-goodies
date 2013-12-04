package DDG::Goodie::Dessert;

use DDG::Goodie;

zci answer_type => 'dessert';
zci is_cached => 0;

primary_example_queries 'a dessert that starts with the letter a';
secondary_example_queries 'dessert that begins with the letter z';
description 'Returns a dessert given a letter.';
name 'Dessert';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Dessert.pm';
category 'food';
topics 'food_and_drink', 'special_interest';
attribution github => ['https://github.com/kennydude', 'kennydude'];
source 'http://food.sulekha.com/dishes/course/desserts/alphabets/a.htm';

triggers start => 'dessert', 'desserts', 'a dessert';

# This function picks a dessert from our lists.
sub itemify {
    # This has our list of desserts.
    my @dessert_list = @{$_[0]};
    # This tells us if we should add an anchor tag or not.
    # We do this because we have two different outputs: HTML and plain text.
    my $is_html = $_[1];

    my $i = rand scalar @dessert_list;
    my $dessert = $dessert_list[$i];

    if($is_html) {
	# Encode spaces so that we can use it as a link.
	$dessert =~ s/\s/+/g;
	return "<a href='http://duckduckgo.com/?q=$dessert+recipe'>" . $dessert_list[$i] . "</a>";
    }
    return $dessert;
};

# This is our list of desserts.
my %desserts = (
	a => ['Apple Turnover', 'Apple Almond Pancake', 'Amaretto Pumpkin Pie', 'Apple Ice Cream', 'Almond Banana Pie', 'Apricot Cherry Compote', 'Autumn Maple Cutout Cookies', 'Apricot Glaze'],
	b => ['Banana Split', 'Banana Fritters', 'Butterscotch Ice Cream', 'Baklava', 'Brazo de Mercedes', 'Black Forest Trifles', 'Brownie Pie', 'Bibingka', 'Button Cookies', 'Buttermilk Pancake'],
	c => ['Cherry Pie', 'Cupcake', 'Chocolate Sundae', 'Caramelized Apple Pie', 'Coffee Walnut Cake', 'Chiffon Cake', 'Cream Puffs', 'Cherry Crunch', 'Creme Brulee', 'Chocolate Mousse'],
	d => ['Dark Chocolate Souffle', 'Doughnut', 'Date Pudding', 'Date and Walnut Cookies', 'Double-Vanilla Meringue Cookies'],
	e => ['Eclair', 'Espresso Cake', 'Easter Bunny Cake', 'Espresso Meringue'],
	f => ['Froyo', 'Fudge Rolls', 'Fig and Honey Ice Cream', 'Fruit Salad', 'Frozen Mango Yogurt', 'Fuzzy Navel Cake', 'Fruit Bar', 'Fried Ice Cream', 'Fruit Flan', 'Fresh Cream Pineapple'],
	g => ['Gingerbread'],
	h => ['Hazelnut Torte'],
	i => ['Ice Cream Sandwich', 'Ice Cream'],
	j => ['Jam roly-poly','Jelly Bean','Jelly'],
	k => ['Key Lime Pie'],
	l => ['Lollipop','Liquorice'],
	m => ['Macaroons','Meringues','Marshmallow','Muffin'],
	n => ['Nougat','Nutella'],
	o => ['Oatmeal Pie','Oreos'],
	p => ['Profiteroles','Pop Tart'],
	q => ['Quiche'],
	r => ['Rocky Road','Red Velvet Cake','Rhubarb and Custard'],
	s => ['Sundae','Strudel','Strawberries and Cream','Soufflé'],
	t => ['Tiramisu','Trifle','Twinkies','Taffy','Toffee'],
	u => ['Upside-down cake'],
	v => ['Vanilla Swirl'],
	w => ['Waffles','Watermelon','White Chocolate'],
	x => ['Xmas Cake'],
	z => ['Zeppole'],
);

handle remainder => sub {
    if(lc $_ =~ m/^(?:that )?(?:start|beginn?)s?(?:ing)? ?(?:with)? (?:the letter )?([a-zA-Z])$/i) {
	my $in = lc $1;
	my $items = $desserts{lc $in};

	my $end = " is a dessert that begins with the letter " . uc $in . '.';

	my $html_output = itemify($items, 1) . $end;
	my $text_output = itemify($items, 0) . $end;
	
	return $text_output, html => $html_output;
    }
    return;
};

1;
