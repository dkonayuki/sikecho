
function prepareUniversities() {
	var container = document.querySelector('#universities-list');
	var msnry = new Masonry( container, {
	  // options
	  "gutter": 10,
	  "isFitWidth": true,
	  itemSelector: '.uni-item'
	});
	
  /*For ajax popup link*/	
  $('#uni-request-btn').magnificPopup({
    // Delay in milliseconds before popup is removed
	  removalDelay: 300,
	
	  // Class that is added to popup wrapper and background
	  // make it unique to apply your CSS animations just to this exact popup
	  mainClass: 'mfp-zoom-in',
	  type: 'ajax',
    callbacks: {
   		parseAjax: function( mfpResponse ) {
        mfpResponse.data = $(mfpResponse.data).find('#new-request');
		  },
	    ajaxContentAdded: function() {
		    // Ajax content is loaded and appended to DOM
			  	
				/*New request*/
				$("#new-request-form").on("submit", function() {
					$.ajax({
					  url: $(this).attr("action"),
					  dataType: "json",
					  data: $(this).serialize(),
					  type: "post",
						success: function() {
							//close popup after submit
							$.magnificPopup.close();
						}
					});
					return false;
				});
				
		  }
		}
	});
}

$(document).on("page:load ready", function() {
	$(".universities.index").ready(function() {
		prepareUniversities();
	});
});