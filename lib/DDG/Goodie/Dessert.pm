package DDG::Goodie::Dessert;

use DDG::Goodie;

sub itemify{
	my @a = $_[0];
	my @i = rand scalar @a;
	return '<a href="http://duckduckgo.com?q=' . @a[@i] . '">' . @a[@i] . '</a>';
};

triggers start => 'dessert', 'desserts';
handle remainder => sub{
	#return unless /^s? (?:that)? ?(?:start|beginn?)(?:ing)? ?(?:with)? ([a-zA-Z])$/i;
	if(lc $_ =~ m/(?:that)? ?(?:start|beginn?)s?(?:ing)? ?(?:with)? ([a-zA-Z])/i){
		my $in = lc $1;
		my $output = 'A Desert beginning with ' . (uc $in) . ' is ';
		my @items;
		if($in eq "a"){
			@items = ('Apple Turnover');
		} elsif($in eq "b"){
			@items = ('Banana Split', 'Biscuits');
		} elsif($in eq "c"){
			@items = ('Cherry Pie', 'Cupcake', 'Chocolate');
		} elsif($in eq "d"){
			@items = ('Donut');
		} elsif($in eq "e"){
			@items = ('Eclair');
		} elsif($in eq "f"){
			@items = ('Froyo', 'Fudge');
		} elsif($in eq "g"){
			@items = ('Gingerbread');
		} elsif($in eq "h"){
			@items = ('Honeycomb');
		} elsif($in eq "i"){
			@items = ('Ice Cream Sandwhich', 'Ice Cream');
		} elsif($in eq "j"){
			@items = ('Jam Rolly Polly','Jelly Bean','Jelly');
		} elsif($in eq "k"){
			@items = ('Key Lime Pie');
		} elsif($in eq "l"){
			@items = ('Lollipop','Liqourice');
		} elsif($in eq "m"){
			@items = ('Macaroons','Meringues','Marshmallow','Muffin');
		} elsif($in eq "n"){
			@items = ('Nougat','Nutella');
		} elsif($in eq "o"){
			@items = ('Oatmeal Pie','Oreos');
		} elsif($in eq "p"){
			@items = ('Profiteroles','Pop Tart');
		} elsif($in eq "q"){
			@items = ('Quiche');
		} elsif($in eq "r"){
			@items = ('Rocky Road','Red Velvet Cake','Ruhbarb and Custard');
		} elsif($in eq "s"){
			@items = ('Sundae','Strudel','Strawberries and Cream','Souflle');
		} elsif($in eq "t"){
			@items = ('Tiramisu','Trifle','Twinkies','Taffy','Toffee');
		} elsif($in eq "u"){
			@items = ('Unicorn Cake','Upside-down cake');
		} elsif($in eq "v"){
			@items = ('Vanilla Swirl');
		} elsif($in eq "w"){
			@items = ('Waffles','Watermelon','White Chocolate');
		} elsif($in eq "x"){
			@items = ('Xmas Cake');
		} elsif($in eq "y"){
			@items = ('Yoghurt');
		} elsif($in eq "z"){
			@items = ('Zepolli','Zucchinni Pie');
		} else{
			return;
		}
		$output .= itemify(@items);
		return $output;
	}
	return;
};

zci is_cached => 0;
1;
