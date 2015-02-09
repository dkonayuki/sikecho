function prepareMasonry() {
	var container = document.querySelector('#universities-list');
	var msnry = new Masonry( container, {
	  // options
	  "gutter": 10,
	  "isFitWidth": true,
	  itemSelector: '.uni-item'
	});
}

function prepareUniversities() {
	
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

function prepareMap() {
	
	// array of map images
	var mapImgs = new Array();
	var defaultID;
	
	// load other map area
	mapImgs[0] = new Image();
	mapImgs[0].src = $("#japan-map-img").attr("src");
	for (i = 1; i <= 9; i++) {
		mapImgs[i] = new Image();
		mapImgs[i].src = "/assets/japan_map" + i + ".png";
	}
		
	// get areaID first time from url
	var areaID = getParameterByName("area");
	if (areaID == null) {
		// 0 is the default img
		defaultID = 0;
	} else {
		// update default image
		defaultID = areaID;
		
		// add active class
		$("#japan-map map area[data-id='" + areaID + "']").addClass("active");
		$("#japan-map span[data-id='" + areaID + "']").addClass("active");
	
		// update the map first time
		$("#japan-map-img").attr("src", mapImgs[areaID].src);
	}

	// mouse event over map areas
	$("#japan-map map area").add("#japan-map span").mouseover(function() {
		var areaID = $(this).data("id");
		//update map
		$("#japan-map-img").attr("src", mapImgs[areaID].src);
	});
	
	//mouse out
	$("#japan-map map area").add("#japan-map span").mouseout(function() {
		//update map
		$("#japan-map-img").attr("src", mapImgs[defaultID].src);
	});
	
	// click on map area
	$("#japan-map map area").add("#japan-map span").on("click", function() {
		if ($(this).hasClass("active")) {
			//click on already active area, change to default map
			defaultID = 0;
			
			//remove active area
			$("#japan-map map area").each(function() {
				$(this).removeClass("active");
			});
			$("#japan-map span").each(function() {
				$(this).removeClass("active");
			});
			
			// update the map
			$("#japan-map-img").attr("src", mapImgs[0].src);
			
			// reload list
			reloadUniversityList();			
			
		} else {
			//click on new area
			areaID = $(this).data("id");
			defaultID = areaID;
			
			//remove other area active
			$("#japan-map map area").each(function() {
				$(this).removeClass("active");
			});
			$("#japan-map span").each(function() {
				$(this).removeClass("active");
			});
			
			// add active class
			$("#japan-map map area[data-id='" + areaID + "']").addClass("active");
			$("#japan-map span[data-id='" + areaID + "']").addClass("active");
			
			// update the map
			$("#japan-map-img").attr("src", mapImgs[areaID].src);
			
			// reload list
			reloadUniversityList();			
		}
		
	});
	
}

/*for university list reload*/
function reloadUniversityList() {
	var data = new Object();

	//check for area selected
	$("#japan-map map area").each(function() {
		if ($(this).hasClass("active")) {
			data.area = $(this).data("id");
		}
	});	
	
	//check if search query
	if ($("#filter-university #search").val() != "") {
		data.search = $("#filter-university #search").val();
	}

  $.ajax({
		//use current locale
	  url: "/" + I18n["meta"]["code"] + "/universities",
	  data: data,
	  success: function() {
	  	//run after js.erb file executed
			prepareMasonry();
			prepareUniversities();
	  },
	  dataType: "script",
		contentType: "application/json"
	});
	
	//replace current url, compatiable with turbolinks
  window.history.replaceState({ turbolinks: true }, "", "/" + I18n["meta"]["code"] + "/universities?" + decodeURIComponent($.param(data, false)));
	//for pushState
	//window.history.pushState({ turbolinks: true, position: window.history.state.position + 1 }, '', page_tab);
}

$(document).on("page:load ready", function() {
	$(".universities.index").ready(function() {
		
	  // disable enter key
	  $("#filter-university").on("submit", function() {
			return false; 
	  });
	  
		$("body").css("background-color", "#fff");
		
	 	/*For live search*/
		var timeout; // add delay time
		$("#filter-university input").keyup(function() {
			window.clearTimeout(timeout); //clear delay
	    timeout = window.setTimeout(reloadUniversityList, 500);
			return false;
		});
		
		prepareMasonry();
		prepareUniversities();
		prepareMap();
		
	});
});