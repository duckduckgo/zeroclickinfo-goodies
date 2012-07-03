package DDG::Goodie::Dessert;

use DDG::Goodie;

sub itemify{
	return '<li><a href="http://duckduckgo.com?q=' . $_[0] . '">' . $_[0] . '</a></li>';
};

triggers start => 'desserts beginning with';
handle remainder => sub{
	if(length($_) == 1){
		my $in = lc $_;
		my $output = 'Deserts beginning with ' . $in . ' are:<ul>';
		if($in eq "a"){
			$output .= itemify('Apple Turnover');
		} elsif($in eq "b"){
			$output .= itemify('Banana Split');
			$output .= itemify('Biscuits');
		} elsif($in eq "c"){
			$output .= itemify('Cherry Pie');
			$output .= itemify('Cupcake');
			$output .= itemify('Chocolate');
		} elsif($in eq "d"){
			$output .= itemify('Donut');
		} elsif($in eq "e"){
			$output .= itemify('Eclair');
		} elsif($in eq "f"){
			$output .= itemify('Froyo');
			$output .= itemify('Fudge');
		} elsif($in eq "g"){
			$output .= itemify('Gingerbread');
		} elsif($in eq "h"){
			$output .= itemify('Honeycomb');
		} elsif($in eq "i"){
			$output .= itemify('Ice Cream Sandwhich');
			$output .= itemify('Ice Cream');
		} elsif($in eq "j"){
			$output .= itemify('Jam Rolly Polly');
			$output .= itemify('Jelly Bean');
			$output .= itemify('Jelly');
		} elsif($in eq "k"){
			$output .= itemify('Key Lime Pie');
		} elsif($in eq "l"){
			$output .= itemify('Lollipop');
			$output .= itemify('Liqourice');
		} elsif($in eq "m"){
			$output .= itemify('Macaroons');
			$output .= itemify('Meringues');
			$output .= itemify('Marshmallow');
			$output .= itemify('Muffin');
		} elsif($in eq "n"){
			$output .= itemify('Nougat');
			$output .= itemify('Nutella');
		} elsif($in eq "o"){
			$output .= itemify('Oatmeal Pie');
			$output .= itemify('Oreos');
		} elsif($in eq "p"){
			$output .= itemify('Profiteroles');
			$output .= itemify('Pop Tart');
		} elsif($in eq "q"){
			$output .= itemify('Quiche');
		} elsif($in eq "r"){
			$output .= itemify('Rocky Road');
			$output .= itemify('Red Velvet Cake');
			$output .= itemify('Ruhbarb and Custard');
		} elsif($in eq "s"){
			$output .= itemify('Sundae');
			$output .= itemify('Strudel');
			$output .= itemify('Strawberries and Cream');
			$output .= itemify('Souflle');
		} elsif($in eq "t"){
			$output .= itemify('Tiramisu');
			$output .= itemify('Trifle');
			$output .= itemify('Twinkies');
			$output .= itemify('Taffy');
			$output .= itemify('Toffee');
		} elsif($in eq "u"){
			$output .= itemify('Unicorn Cake');
			$output .= itemify('Upside-down cake');
		} elsif($in eq "v"){
			$output .= itemify('Vanilla Swirl');
		} elsif($in eq "w"){
			$output .= itemify('Waffles');
			$output .= itemify('Watermelon');
			$output .= itemify('White Chocolate');
		} elsif($in eq "x"){
			$output .= itemify('Xmas Cake');
		} elsif($in eq "y"){
			$output .= itemify('Yoghurt');
		} elsif($in eq "z"){
			$output .= itemify('Zepolli');
			$output .= itemify('Zucchinni Pie');
		} else{
			return;
		}
		$output .= '</ul>';
		return $output;
	}
	return;
};

zci is_cached => 1;
1;
