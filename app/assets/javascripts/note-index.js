	
/*for notes list reload*/
function reloadNoteList() {
	var data = new Object();
	
	//add filter
	data.filter = $(".filter-menu .active").data("type");
	
	//check if order option is needed
	data.order = $("#note-order-option select.selectpicker option:selected").val();
	
	//check layout option
	$("#note-layout-option button").each(function() {
		if ($(this).hasClass("active")) {
			data.layout = $(this).data("type");
		}
	});
	
	//check if search query
	if ($("#note-search #search").val() != "") {
		data.search = $("#note-search #search").val();
	}

  $.ajax({
		//use current locale
	  url: "/" + I18n["meta"]["code"] + "/notes",
	  data: data,
	  dataType: "script",
		contentType: "application/json"
	});
	
	//replace current url, compatiable with turbolinks
  window.history.replaceState({ turbolinks: true }, "", "/" + I18n["meta"]["code"] + "/notes?" + decodeURIComponent($.param(data, false)));
	//for pushState
	//window.history.pushState({ turbolinks: true, position: window.history.state.position + 1 }, '', page_tab);
}

function prepareLoadNotePage() {
	// need to set active class for filter menu
	var filter = getParameterByName("filter");
	if (filter == null) {
		//default
		$(".filter-menu a[data-type='all']").addClass("active");
		$("#mp-menu a[data-type='all']").addClass("active");
	} else {
		$(".filter-menu a[data-type='" + filter + "']").addClass("active");
		$("#mp-menu a[data-type='" + filter + "']").addClass("active");
	}
	// dont need to check order options from js because user settings is used in view/model
}

$(document).on("page:load ready", function() {
	$(".notes.index").ready(function() {
		
		$("body").css("background-color", "#fff");
		$('.selectpicker').selectpicker();
		prepareLoadNotePage();

		/*For live search*/
		var timeout; // add delay time
	  $("#note-search input").keyup(function() {
			window.clearTimeout(timeout); //clear delay
	    timeout = window.setTimeout(reloadNoteList, 500);

			return false;
	  });

	  /*For note order option*/
		$('#note-order-option .selectpicker').on("change", function () {
    	reloadNoteList();
		});
		
		/*For note layout option*/
	 	$("#note-layout-option button").on("click", function() {
	 		$("#note-layout-option button").each(function() {
	 			$(this).removeClass("active");
	 		});
	 		$(this).addClass("active");
			reloadNoteList();
	 	});
	 	
	 	/*For mobile push menu active*/
		var pushMenu = new mlPushMenu( document.getElementById('mp-menu'), document.getElementById('pushmenu-trigger') );
	 	$("#mp-menu li a").off("click").on("click", function() {
	  	$("#mp-menu li a").each(function() {
	  		$(this).removeClass("active");
	  	});
	  	$(this).addClass("active");
	  	$(".filter-menu li a").each(function() {
	  		$(this).removeClass("active");
	  	});
	  	$(".filter-menu li a[data-type=" + $(this).data("type") + "]").addClass("active");
	  	//close push menu
	  	pushMenu._resetMenu();
	  	
	  	reloadNoteList();
		  return false;
		});
	 	
	 	/*For filter menu active*/
	 	$(".filter-menu li a").off("click").on("click", function() {
	  	$(".filter-menu li a").each(function() {
	  		$(this).removeClass("active");
	  	});
	  	$(this).addClass("active");
	  	$("#mp-menu li a").each(function() {
	  		$(this).removeClass("active");
	  	});
	  	$("#mp-menu li a[data-type=" + $(this).data("type") + "]").addClass("active");
	  	
	  	reloadNoteList();
		  return false;
		});
		
		/*For endless page*/
		if ($("#notes .hidden-pagination").length) {
			$(window).scroll(function(){
				url = $("#notes .next a").attr("href");
		    if (url && ($(window).scrollTop() > $(document).height() - $(window).height() - 50)) {
		    	//disable pagination link
		    	$("#notes .pagination").text("fetching...");
		    	//append loading.gif
	  			$("#notes-list").append("<div id='loading'><img src='/assets/loading.gif'></div>");
					$.getScript(url);
		    }
			});
		}
		
	});
});