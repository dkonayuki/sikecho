$(document).on("page:load ready", function() {
	$(".notes.show").ready(function() {
		
		/*author's card will appear when user hovers over*/
		$(".author-hovercard-target").hovercard({
			content: $(".author-hovercard"),
			placement: "top"
		});
		
		/*subject's card will appear when user hovers over*/
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
	  var documentID;
	  $(".document-popup").magnificPopup({
	    // Delay in milliseconds before popup is removed
		  removalDelay: 300,
		
		  // Class that is added to popup wrapper and background
		  // make it unique to apply your CSS animations just to this exact popup
		  mainClass: "mfp-zoom-in",
		  type: "ajax",
	    callbacks: {
	   		parseAjax: function( mfpResponse ) {
	        mfpResponse.data = $(mfpResponse.data).find("#show-document");
			  },
		    ajaxContentAdded: function() {
			    // Ajax content is loaded and appended to DOM
					ajaxSuccess();
					
					// prepare comments from document-show.js
					prepareComments();
					
					// remember documentID to unsubscribe later
					documentID = $("#show-document").data("id");
			  },
			  close: function() {
			  	// unsubscribe when closing popup
					faye.unsubscribe("/documents/" + documentID);
      	}
			}
		});
							
		// document navigation
		$("body").on("click", ".document-navigation-btn", function() {
			//$(".mfp-zoom-in").removeClass("mfp-zoom-in").addClass("mfp-rtl");
    	//$.magnificPopup.close();
    	
	  	// unsubscribe old document
			faye.unsubscribe("/documents/" + documentID);
			
			// replace with new popup
    	$.magnificPopup.open({
		    // Delay in milliseconds before popup is removed
			  removalDelay: 300,
        items: {
        	src: $(this).attr("href")
        },
			  type: "ajax",
			  callbacks: {
		   		parseAjax: function( mfpResponse ) {
		        mfpResponse.data = $(mfpResponse.data).find("#show-document");
				  },
			    ajaxContentAdded: function() {
				    // Ajax content is loaded and appended to DOM
						ajaxSuccess();
						
						// prepare comments from document-show.js
						prepareComments();
						
						// remember new documentID
						documentID = $("#show-document").data("id");
				  },
				  close: function() {
				  	// unsubscribe when closing popup
						faye.unsubscribe("/documents/" + documentID);
	      	}
				}
			});
    	return false;
		});
		
	});//end of ready function
});