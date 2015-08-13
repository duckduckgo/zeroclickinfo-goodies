DDH.javascript_only = DDH.javascript_only || {};

DDH.javascript_only.build = function(ops){
    ops.data.title = 'Javascript Only';
	ops.data.subtitle = 'No Perl';
    ops.data.content = 'This amazingly static instant answer required no Perl module to be created by the author';
	ops.templates = {
		group:'text',
		options:{
			moreAt:false
		}
	};
    return ops;
}
