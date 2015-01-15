$(document).on("page:load ready", function() {
	$(".home.index").ready(function() {

		$("body").css("background-color", "#fff");
		prepareUniversities();

		/*var faye = new Faye.Client(fayeServerURL);
		faye.subscribe("/test", function(data) {
			alert(data);
		});*/
		
	});//end of ready function
});