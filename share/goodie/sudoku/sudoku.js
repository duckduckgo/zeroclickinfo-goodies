Handlebars.registerHelper("moduloIf", function(index_count,mod,block)
{
	if(parseInt(index_count)%(mod)=== 0)
		return block.fn(this);
});

Handlebars.registerHelper('ifBlank', function(value)
{
	if(value==0)
		return new Handlebars.SafeString("<input maxlength='1'/>")
	else
		return this;
});
