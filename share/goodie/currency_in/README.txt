parser.py generates currencies.txt for 'CurrencyIn.pm' module.

Currencies for each country are from:
http://en.wikipedia.org/wiki/List_of_circulating_currencies

First run: 'fetch.sh' to fetch wikipedia page used by parser,
then run: 'parse.sh' or just 'python parse.py'


DETAILS:
Output is the file (currencies.txt) with list of countries and currencies with iso code in ()
For example:
slovakia
Euro (EUR)

If there is more than one currency used by each country then each currency is separated by comma
For example:
zimbabwe
Botswana pula (BWP),British pound (GBP)

Country name is lowercased for better comparison with user input. But it gets capitalized in search results.
