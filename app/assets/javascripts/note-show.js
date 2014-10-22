$(document).on("page:load ready", function() {
	$(".notes.show").ready(function() {
		
		$(".author-hovercard-target").hovercard({
			content: $(".author-hovercard"),
			placement: "top"
		});
		
		$(".subject-hovercard-target").each(function() {
			var id = $(this).parents(".subject-card").data("id");
			$(this).hovercard({
				content: $(".subject-hovercard[data-id='" + id + "']")
			});
		});
		
		/*For print button*/
		$(".print").on("click", function() {
			window.print();
			return false;
		});
		
	  /*For ajax popup link in show note page*/	
	  $('.document-popup').magnificPopup({
	    // Delay in milliseconds before popup is removed
		  removalDelay: 300,
		
		  // Class that is added to popup wrapper and background
		  // make it unique to apply your CSS animations just to this exact popup
		  mainClass: 'mfp-zoom-in',
		  type: 'ajax',
	    callbacks: {
	   		parseAjax: function( mfpResponse ) {
	        mfpResponse.data = $(mfpResponse.data).find('#show-document');
			  },
		    ajaxContentAdded: function() {
			    // Ajax content is loaded and appended to DOM
					ajaxSuccess();
					prepareComments();
			  }
			}
		});
		
	});//end of ready function
});