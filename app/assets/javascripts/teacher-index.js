function prepareTeacherMasonry() {
	var container = document.querySelector("#teachers-list-wrapper");
	var msnry = new Masonry( container, {
	  // options
	  "gutter": 10,
	  "isFitWidth": true,
	  itemSelector: ".teacher"
	});
}

function prepareTeacherIndex() {
	prepareTeacherMasonry();
	
	/*teacher's card will appear when user hovers over*/
	$(".teacher-hovercard-target").each(function() {
	var id = $(this).parents(".teacher").data("id");
		$(this).hovercard({
			content: $(".teacher-hovercard[data-id='" + id + "']"),
			placement: "bottom",
		});
	});
	
}

$(document).on("page:load ready", function() {
	$(".teachers.index").ready(function() {
		
		prepareTeacherIndex();
		
	});//end of ready function
});