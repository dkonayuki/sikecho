function prepareComments() {
	
	/* auto resize for textarea 
	 * textarea will expand automatically when type in
	 */
  $("textarea").autosize();
  
  $("#new-comment .comment-btn").prop("disabled", true);
  $("#new-comment #comment-content").keyup(function() {
	  $("#new-comment .comment-btn").prop("disabled", $(this).val() == "" ? true : false);
  });
	
	/*setting up faye for pub/sub*/
	var documentID = $("#show-document").data("id");
	var faye = new Faye.Client(fayeServerURL);
	
	//subscribe to specified id channel only
	faye.subscribe("/documents/" + documentID, function(data) {
		//execute js
		eval(data);
	});
	
			
	/*For comment pagination*/
	$("#comments-pagination").on("click", "#comment-next-page", function() {
		var url = $(".hidden-pagination .next a").attr("href");
		if (url) {
			// hide pagination in case user click too many times
    	$(".pagination").text("fetching...");

    	//append loading.gif
			$('#comments-pagination').append("<div id='loading-inline'><img src='/assets/loading.gif'></div>");
			$.getScript(url);
		}
		return false;
	});
};
		
$(document).on("page:load ready", function() {
	$(".documents.show").ready(function() {
		
		prepareComments();
		
	});//end of ready function
});