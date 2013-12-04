package DDG::Goodie::Dessert;

use DDG::Goodie;
use utf8;

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
	g => ['Gingerbread', 'Graham Cracker Pie', 'Gingery Plum Jam', 'Gingersnaps', 'Grilled Fruit Sundae', 'Gingerbread Biscotti'],
	h => ['Hazelnut Torte', 'Honey Nut Crunch', 'Heart-Shaped Napoleons', 'Honey Cinnamon Cake'],
	i => ['Ice Cream Sandwich', 'Irish Cream-Espresso Crème Caramel', 'Italian Chocolate Truffle', 'Italian Cake'],
	j => ['Jam roly-poly', 'Jelly Cake', 'Jam Crostata', 'Jam-Filled Cookies'],
	k => ['Key Lime Pie', 'Kiwi Cheesecake', 'Kit Kat'],
	l => ['Lollipop', 'Liquorice', 'Lychee Sorbet', 'Lemon Fluff Pie', 'Linzer Cookies', 'Lemon Frozen Yogurt', 'Lemon Meringue Pie', 'Low-Fat Cherry Cobbler'],
	m => ['Macaroons', 'Meringues', 'Marshmallow', 'Morning Glory Muffins', 'Mango Pudding', 'Madeira Cake', 'Mango Fool', 'Mocha Parfait', 'Mint Fudge Tart', 'Marlborough Pie'],
	n => ['Nougat', 'Nutella', 'Nutty Graham Cake', 'New York Cheesecake', 'Noodle Pudding'],
	o => ['Oatmeal Pie', 'Oreos', 'Orange Muffins', 'Oreo Cookie Cheesecake', 'Orange Chiffon Cake', 'Olympic Gold Medal Cookies'],
	p => ['Profiteroles', 'Pop Tart', 'Pumpkin Pie', 'Pineapple Cake', 'Pistachio Ice Cream', 'Peanut Butter Cupcakes', 'Plum Pudding', 'Pumpkin Fudge'],
	q => ['Quiche', 'Quinoa Apple Pie', 'Queen of Puddings', 'Quebec Sugar Pie'],
	r => ['Rocky Road','Red Velvet Cake','Rhubarb and Custard', 'Raisin Muffins', 'Raspberry Jam Hearts', 'Rainbow Cake', 'Rice Pudding', 'Rum Cake'],
	s => ['Sundae', 'Strudel', 'Strawberries and Cream', 'Soufflé', 'Sponge Cake', 'Strawberry Trifle', 'Sweet Potato Pudding', 'Stuffed Granny Smiths'],
	t => ['Tiramisu', 'Trifle', 'Twinkies', 'Taffy', 'Toffee Bars', 'Tropical Paradise Pancakes', 'Tangerine Creme Brulee', 'Tres Leches Cake', 'Tea Cake'],
	u => ['Upside-down cake', 'Unbaked Chocolate Cookies', 'Ultimate Chocolate Cake', 'Upside Down Orange Cake'],
	v => ['Vanilla Swirl', 'Valentine Cake', 'Vanilla Poached Peaches', 'Vanilla Pudding', 'Valentine Cupcakes'],
	w => ['Waffles','Watermelon','White Chocolate', 'Whole Wheat Muffins', 'Walnut Fudge', 'White Chocolate Snowflakes', 'Watermelon Pie'],
	x => ['Xmas Cake'],
        y => ['Yellow Layer Cake', 'Yogurt Fruit Pops', 'Yogurt Sundae', 'Yogurt Cheesecake'], 
	z => ['Zeppole', 'Zucchini Cake', 'Zebra-Stripe Cheesecake'],
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
