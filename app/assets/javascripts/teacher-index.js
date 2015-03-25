function prepareTeacherMasonry() {
	var container = document.querySelector("#teachers-list");
	var msnry = new Masonry( container, {
	  // options
	  "gutter": 10,
	  "isFitWidth": true,
	  itemSelector: ".teacher"
	});
}

$(document).on("page:load ready", function() {
	$(".teachers.index").ready(function() {
		
		prepareTeacherMasonry();
		
	});//end of ready function
});