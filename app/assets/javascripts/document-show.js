function prepareComments() {
	
	/* auto resize for textarea 
	 * textarea will expand automatically when type in
	 */
  $('textarea').autosize();
	
	/*setting up faye for pub/sub*/
	var documentID = $("#show-document").data("id");
	var faye = new Faye.Client(fayeServerURL);
	
	//subscribe to specified id channel only
	faye.subscribe("/documents/" + documentID, function(data) {
		//execute js
		eval(data);
	});
};
		
$(document).on("page:load ready", function() {
	$(".documents.show").ready(function() {
		
		prepareComments();
		
	});//end of ready function
});