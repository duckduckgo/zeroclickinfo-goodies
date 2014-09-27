var currentFont = $('#figlet-dropdown').val();

$('#figlet-dropdown').change( function( event ) {
    // Prepare url for redirect
    var newFont = $('#figlet-dropdown').val();
    var url = location.href.replace( currentFont, newFont )

    location.href = url;
});
