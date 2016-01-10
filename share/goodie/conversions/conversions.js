DDH.conversions = DDH.conversions || {};

DDH.conversions.build = function(){
	return {
		onShow: function() {
			$("#zci__conversions-left-in, #zci__conversions-left-unit").change(function(){
			
				var query = $("#zci__conversions-left-in").val() + " " + $("#zci__conversions-left-unit").val() + " in " + $("#zci__conversions-right-unit").val();
				
				$.getJSON("https://set.mintsoft.net/ddg-api/proxy.php?format=json&q="+query, function(data){
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
		}
	};
};