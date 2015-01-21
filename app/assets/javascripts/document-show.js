function prepareComments() {
	/* auto resize for textarea */
  $('textarea').autosize();

	/*New comment*/
	/*$("#comment-form").on("submit", function() {
		$.ajax({
		  url: $(this).attr("action"),
		  dataType: "script",
		  data: $(this).serialize(),
		  type: $(this).attr("data-method"),
		  success: function() {
		  	$("#comment-content").val("");
		  }
		});
		return false;
	});*/
	
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