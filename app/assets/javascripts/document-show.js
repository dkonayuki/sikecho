function prepareComments() {
	
	/* show more btn event*/
	$("body").on("click", ".media-show-more", function() {
		$(this).parent().hide();
		$(this).parents(".media-content").find(".text-exposed-show").css("display", "block");
		return false;
	});
	
	/* auto resize for textarea 
	 * textarea will expand automatically when type in
	 */
  $("textarea").autosize();
  
	/*setting up faye for pub/sub*/
	var documentID = $("#show-document").data("id");
	
	//faye for pub/sub
	try {
		//unsubscribe first
    window.faye.unsubscribe("/documents/" + documentID);
	}
	catch(err) {
	}
		
	//subscribe to specified id channel only
	faye.subscribe("/documents/" + documentID, function(data) {
		//execute js
		eval(data);
	});
	
	/*For comment pagination*/
	$("#comments-pagination").on("click", "#comment-next-page", function() {
		var url = $("#show-document .hidden-pagination .next a").attr("href");
		if (url) {
			// hide pagination in case user click too many times
    	$(".pagination").text("fetching...");

    	//append loading.gif
			$("#comments-pagination").append("<div id='loading-inline'><img src='/assets/loading.gif'></div>");
			$.getScript(url);
		}
		return false;
	});
	
	//disable commment btn at beginning
  $("#new-comment .comment-btn").prop("disabled", true);
  
  //check if comment content has enough characters
  $("#new-comment #comment-content").keyup(function() {
  	$("#new-comment .comment-btn").prop("disabled", (($(this).val().length >= 4) && ($(this).val().length <= 150)) ? false : true);
  });
	
};
		
$(document).on("page:load ready", function() {
	$(".documents.show").ready(function() {
		
		prepareComments();
		
	});//end of ready function
});