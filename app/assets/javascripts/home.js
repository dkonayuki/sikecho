$(document).on("page:load ready", function() {
	$(".home.index").ready(function() {

		/*var faye = new Faye.Client(fayeServerURL);
		faye.subscribe("/test", function(data) {
			alert(data);
		});*/
		
		/*author's card will appear when user hovers over*/
		$(".user-activity-hovercard-target").each(function() {
			var id = $(this).parents(".activity").data("id");
			$(this).hovercard({
				content: $(".user-activity-hovercard[data-id='" + id + "']"),
				placement: "bottom"
			});
		});
		
	});//end of ready function
});