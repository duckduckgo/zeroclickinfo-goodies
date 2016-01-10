DDH.conversions = DDH.conversions || {};

DDH.conversions.build = function(){
	// http://api.duckduckgo.com/?q=minecraft+cake&format=json&pretty=1
	
	return {
		onShow: function() {
			$("#zci__conversions-left-in").change(function(){
				console.log("onchange executed");
				var query = $(this).val() + " " + $("#zci__conversions-left-unit").val() + " in " + $("#zci__conversions-right-unit").val();
				
				$.ajax({
					url: "https://api.duckduckgo.com/",
					data: { 
						q: query,
						format: 'json'
					},
					method: 'get',
					dataType: 'json',
					done: function(data) {
						console.log("AJAX success",data);
					}
				});
				
			});
		}
	};
};