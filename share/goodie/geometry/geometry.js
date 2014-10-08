//We must wait for geometry.css
$(window).load(function(){
	//get all formulas
	$("#zci--geometry-formulas div").each(function(){
		//get the svg shape (it has the data-formula attribute with the first letter of the formula)
		var svg = $("#zci--geometry-svg [data-formula=" + $(this).text().match(/:(\w)/)[1] + "]");//matches the formula symbol
		var formula = this;
		//No svg shape for this formula
		if(!svg.length) return;
		//this is for the double-hover effect
		//if the formula is hovered, the class hover is added to the svg shape
		$(this).hover(function(){
			svg.each(function(){
				this.classList.add("hover");
			});
		}, function(){
			svg.each(function(){
				this.classList.remove("hover");
			});
		});

		//if the svg shape is hovered, the class hover is added to the formula
		svg.hover(function(){
			formula.classList.add("hover");
		}, function(){
			formula.classList.remove("hover");
		});
	});
	var svg = $("#zci--geometry-svg");
	//set SVG height to the same height as the formulas
	svg.height($("#zci--geometry-formulas").height());
	//the svg is first hidden; if the CSS is not loaded, there is a black big shape
	svg.show();
});
