$(document).on("page:load ready", function() {
	$(".users.show").ready(function() {

		//For ajax popup link in profile page
	  $(".education-show-popup").magnificPopup({
	    // Delay in milliseconds before popup is removed
		  removalDelay: 300,
		
		  // Class that is added to popup wrapper and background
		  // make it unique to apply your CSS animations just to this exact popup
		  mainClass: "mfp-zoom-in",
		  type: "ajax",
	    callbacks: {
	   		parseAjax: function( mfpResponse ) {
	        mfpResponse.data = $(mfpResponse.data).find("#education-show");
			  },
		    ajaxContentAdded: function() {
					
			  }
			}
		});
				
	});//end of ready function
});