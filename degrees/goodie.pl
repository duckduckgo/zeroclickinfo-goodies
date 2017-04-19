# Converts temperatures between these units : Celcius, Kelvin & Fahrenheit
# examples : (casing does not matter)
    # 2 celcius to kelvin
    # 10 Fahrenheit to Kelvin
    # 100 kelvin in Celcius

if (!$type && $q =~ m/^(\d+[.]\d*|\d*[.]\d+|\d+)\s(Celcius|Kelvin|Fahrenheit)+\s(in|to)\s(Celcius|Kelvin|Fahrenheit)$/i) {
    
    my $result = 0; 

    if ($2 && ucfirst $2 eq "Celcius") {
	# X Celcius to otherUnit
	if ($4 && ucfirst $4 eq "Fahrenheit") {
	    # X Celcius to Fahrenheit
	    $result = $1 * 9/5 + 32;
	    $answer_results = "$1°C = $result°F";
	}
	elsif ($4 && ucfirst $4 eq "Kelvin") {
	    # X Celcius to Kelvin
	    $result = $1 + 273.15;
	    $answer_results = "$1°C = $result°K";
	}
    }
    elsif ($2 && ucfirst $2 eq "Kelvin") {
	# X Kelvin to otherUnit
	if ($4 && ucfirst $4 eq "Fahrenheit") {
	    # X Kelvin to Fahreneiht
	    $result = ($1 - 273.15)*9/5 + 32;
	    $answer_results = "$1°K = $result°F";
	}
	elsif ($4 && ucfirst $4 eq "Celcius") {
	    # X Kelvin to Celcius
	    $result = ($1 - 273.15);
	    $answer_results = "$1°K = $result°C";
	}
    }
    elsif ($2 && ucfirst $2 eq "Fahrenheit") {
	# X Fahrenheit to otherUnit
	if ($4 && ucfirst $4 eq "Celcius") {
	    # X Fahrenheit to Celcius
	    $result = ($1 - 32)*5/9;
	    $answer_results = "$1°F = $result°C";
	}
	elsif ($4 && ucfirst $4 eq "Kelvin") {
	    # X Fahrenheit to Kelvin
	    $result = ($1 - 32)*5/9 + 273.15;
	    $answer_results = "$1°F = $result°K";
	}
    }
    if ($answer_results) {
	$answer_results = qq($answer_results);
	$answer_type = "degree";
    }
}
