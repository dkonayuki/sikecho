
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
	
 	/*For live search*/
	var timeout; // add delay time
	$("#filter-university input").keyup(function() {
		window.clearTimeout(timeout); //clear delay
    timeout = window.setTimeout(reloadUniversityList, 500);
		return false;
	});
}

/*for university list reload*/
function reloadUniversityList() {
	var data = new Object();
	
	/*
	$("#note-order-option button").each(function() {
		if ($(this).hasClass("active")) {
			data.order = $(this).data("type");
		}
	});*/
	
	//check if search query
	if ($("#filter-university #search").val() != "") {
		data.search = $("#filter-university #search").val();
	}

  $.ajax({
		//use current locale
	  url: "/" + I18n["meta"]["code"] + "/universities",
	  data: data,
	  //success: ajaxSuccess,
	  dataType: "script",
		contentType: "application/json"
	});
	
	//replace current url, compatiable with turbolinks
  window.history.replaceState({ turbolinks: true }, "", "/" + I18n["meta"]["code"] + "/universities/" + decodeURIComponent($.param(data, false)));
	//for pushState
	//window.history.pushState({ turbolinks: true, position: window.history.state.position + 1 }, '', page_tab);
}

$(document).on("page:load ready", function() {
	$(".universities.index").ready(function() {
		$("body").css("background-color", "#fff");
		prepareUniversities();
	});
});