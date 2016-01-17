DDH.conversions = DDH.conversions || {};

DDH.conversions.build = function(){
	var defaultUnit = {
		mass: {left: 'ton', right: 'kilogram'},
		length: {left: 'km', right: 'metres'},
		area: {left: 'hectare', right: 'square metres'},
		volume : { left: 'litre', right: 'cubic cm'},
		duration: {left: 'day', right: 'seconds'},
		pressure: {left: 'atmosphere', right: 'pascal'},
		energy: {left: 'kilowatt hour',right: 'joule'},
		power: {left: 'kilowatt', right: 'watt'},
		angle: {left: 'radian', right: 'degrees'},
		force: {left: 'newton', right: 'dyne'},
		temperature: {left: 'celsius', right:'kelvin'},
		digital: {left:' kibibyte', right:'byte'}
	};
	return {
		onShow: function() {
			$("#zci__conversions-left-in, #zci__conversions-left-unit, #zci__conversions-right-unit").change(function(){
			
				var query = $("#zci__conversions-left-in").val() + " " + $("#zci__conversions-left-unit").val() + " in " + $("#zci__conversions-right-unit").val();
				
				$.getJSON("https://crossorigin.me/"+"https://api.duckduckgo.com/?format=json&q="+query, function(data){
//				$.getJSON("https://api.duckduckgo.com/?format=json&q="+query, function(data){
					var answerComponents = data.Answer.match(/^([0-9\.,]+) ([a-zA-Z].*)$/);
					// numbers are output with "," delimiters from the text output, which nothing supports in the
					// input type=number fields
					var answerValue = answerComponents[1].replace(/,/g,"");
					
					console.log(answerValue);
					
					$("#zci__conversions-right-in").val(answerValue);
					$("#zci__conversions-right-unit").val(answerComponents[2]);
				});
			});
			$("#zci__conversions-physical-quantity").change(function(data){
				$("#zci__conversions-left-in").val(1);
				
				$("#zci__conversions-left-unit").val( defaultUnit[$(this).val()].left );
				$("#zci__conversions-right-unit").val( defaultUnit[$(this).val()].right );
			});
		}
	};
};