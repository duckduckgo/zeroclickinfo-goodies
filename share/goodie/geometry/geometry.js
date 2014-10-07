$(document).ready(function(){
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
});
