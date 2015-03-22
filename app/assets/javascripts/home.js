$(document).on("page:load ready", function() {
	$(".home.index").ready(function() {

		/*author's card will appear when user hovers over*/
		$(".user-activity-hovercard-target").each(function() {
			var id = $(this).parents(".activity").data("id");
			$(this).hovercard({
				content: $(".user-activity-hovercard[data-id='" + id + "']"),
				placement: "bottom"
			});
		});
		
		/*For endless page*/
		if ($("#home .hidden-pagination").length) {
			$(window).scroll(function(){
				url = $("#home .next a").attr("href");
		    if (url && ($(window).scrollTop() > $(document).height() - $(window).height() - 50)) {
		    	//disable pagination link
		    	$("#home .pagination").text("fetching...");
		    	//append loading.gif
	  			$("#activities").append("<div id='loading'><img src='/assets/loading.gif'></div>");
					$.getScript(url);
		    }
			});
		}
		
	});//end of ready function
});