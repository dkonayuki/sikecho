// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require turbolinks
//= require bootstrap-sprockets
//= require bootstrap-select.js
//= require bootstrap-tagsinput.js
//= require handlebars.js
//= require typeahead.bundle.js
//= require wysihtml5
//= require bootstrap-editable
//= require jquery-fileupload
//= require jquery.fileupload.locale.js
//= require jquery.magnific-popup.js
//= require jquery.autosize
//= require owl.carousel.js
//= require fileinput.js
//= require masonry.pkgd.js
//= require jquery.gritter.js
//= require jquery.hovercard.js
//= require jquery.readyselector.js
//= require modernizr.custom.js
//= require classie.js
//= require mlpushmenu.js
//= require jquery.nanoscroller.js
//= require_tree .

/*MaxWidth for ajax popup*/
function setMaxWidth() {
	
	//for desktop page
	if ($(window).width() >= 768) {
		if ($("#document-content").length) {
			$("#document-content").css("maxWidth", ( $("#show-document").width() - $("#document-comment-section").width() - 30 ) + "px"); //30 for scroolbar				
		}
		//search form in navbar
		$("#navbar-collapse-2").css("width", $("#nav-bar").width() - $("#logo").innerWidth() - $("#navbar-collapse-1").width() - $("#navbar-collapse-3 ul").innerWidth() - 60 - 25 + "px");//25 for scroolbar	60 for calendar img and padding			
	}
	
	//set dynamic width for subject recommend
	if ($(".subject-recommend-item").length) {
		$(".subject-recommend-info").css("maxWidth", ( $('.subject-recommend-item').width() - 10) + "px" );
	}
	
	//search form will shrink when window size is too small. max-width = 200px
	if ($("#subject-search").length) {
		$("#subject-search").css("width", $("#subjects-content").width() - $("#new-subject-btn").outerWidth(true) - 40);
	}

	//search form will shrink when window size is too small. max-width = 220px
	//15px is for space between search form and new note btn
	if ($("#note-search").length) {
		$("#note-search").css("width", $("#note-menu").width() - $("#pushmenu-trigger").outerWidth(true) - $(".filter-menu").width() - $("#new-note-btn").outerWidth(true) - 15);
	}
	
}

/*Scroll to anchor*/
function scrollToAnchor(aid){
  var aTag = $("a[name='"+ aid +"']");
  $("html,body").animate({ scrollTop: aTag.offset().top - 51 }, "fast");
}

/*Define after ajax success*/
function ajaxSuccess() {
	
	/*For note dynamic max width*/
	$(window).on( "resize", setMaxWidth ); //Remove this if it's not needed. It will react when window changes size.
	
	setMaxWidth();
	
	//load more items if needed
	$(window).scroll();		
}

/*get url params*/
function getParameterByName(key,target){
	var values = [];
	if(!target){
    target = location.href;
	}
	
	key = key.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
	
	var pattern = key + '=([^&#]+)';
	var o_reg = new RegExp(pattern,'ig');
	while(true){
    var matches = o_reg.exec(target);
    if(matches && matches[1]){
      values.push(decodeURIComponent(matches[1]));
    }
    else{
      break;
    }
	}
	
	if(!values.length){
		return null;   
	}
	else {
		return values;
	}

}

function prepareFirstTime() {
	//Remove this if it's not needed. It will react when window changes size.
	$( window ).on( "resize", setMaxWidth );
	
	/*For note dynamic max width first time*/
	$(window).scroll();
	setMaxWidth();
}

function prepareNotification() {
	
	if ($("#notification-dropdown").length) {
		//refresh notification count
		$.getScript("/refresh_notification_count");
		
		//dropdown menu shown event
		$("#notification-dropdown").on("shown.bs.dropdown", function () {
			
			//add loading
			$("#notification-dropdown-list").append("<div id='loading'><img src='/assets/loading.gif'></div>");
			
			//refresh list
			$.getScript("/refresh_notification_list", function() {
				//nano slider
				$(".nano").nanoScroller();
				
				//on click notification
				$(".notification").each(function() {
					var activityID = $(this).data("id");
					
					$(this).on("click", "a", function() {
						$.ajax({
						  url: "/read",
						  dataType: "script",
						  data: {id: activityID},
						  success: function() {
						  	//refresh count after read
						  	$.getScript("/refresh_notification_count");
						  }
						});
					});
				});
			});
		
		});
	
		//mark as read all
		$("#notification-dropdown-menu").on("click", "a", function() {
			$.getScript("/mark_as_read_all", function() {
				//refresh count after mark as read all
				$.getScript("/refresh_notification_count");
			});
			return false;
		});
		
		//faye for pub/sub
		//userId will be stored in #notification-dropdown div
		var userID = $("#notification-dropdown").data("id");
		try {
			//unsubscribe first
	    window.faye.unsubscribe("/users/" + userID);
		}
		catch(err) {
		}
		
		//create new client
		window.faye = new Faye.Client(fayeServerURL);
		
		//subscribe to current user channel
		faye.subscribe("/users/" + userID, function(data) {
			//execute js
			eval(data);
		});
	}

}

$(document).ready(function() {

});

/* will run on all pages
 * use page:load for turbolinks */
$(document).on("page:load ready", function() {
	
	prepareFirstTime();
	prepareNotification();
	
  // disable enter key in filter form
  $(".search-form").on("submit", function() {
		return false; 
  });

	/*For tooltip*/
	$(".has-tooltip").tooltip({
    'container':'body'
  });
  
  /*For search bar submit on navbar*/
  $(".search-bar").on("submit", function() {
  	// default search is subject
  	//window.location.href = "/" + I18n["meta"]["code"] + "/search?query=" + $(this).find("#query").val() + "&type=subject";
  	//redirect to other page when submit
  	window.location.href = "/" + I18n["meta"]["code"] + "/subjects?search=" + $(this).find("#search").val();
  	return false;
  });
  
  /*get subject list from search controller*/
  var subjectsList = new Bloodhound({
	  datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
	  queryTokenizer: Bloodhound.tokenizers.whitespace,
	  //prefetch: '/subjects.json',
	  remote: '/search?q=%QUERY'
	});
	subjectsList.initialize();
	
	/*Initiate typeahead*/
	//$(".typeahead").typeahead("destroy");
	$('.typeahead').typeahead(null, {
	  displayKey: 'name',
	  source: subjectsList.ttAdapter(),
	  templates: {
			//empty: ,
	    suggestion: Handlebars.compile(
	      "<div class='subject-typeahead-item'>" +
		      "<a href={{typeahead_subject_path}}>" +
			      "<img src='{{typeahead_thumbnail}}'></img>" +
			      "<div class='subject-typeahead-content'>" +
			      	"<div class='subject-typeahead-name'>{{name}}</div>" +
			      	"<div class='subject-typeahead-info'>{{teachers.0.full_name}} &bull; {{year}}</div>" +
			      "</div>" +
		      "</a>" +
	      "</div>"
	    )
	  }
	});
	
	/*Fix keyboard focus on iphone*/
  if (navigator.userAgent.match("CriOS")) {
		$("input").not(".search-bar #search").on("focus", function() {
	    $("#nav-bar").css("position", "absolute");
		});
		$("input").not(".search-bar #search").on("blur", function() {
	    $("#nav-bar").css("position", "fixed");
		});
	}
	
	/*check if scrollbar exists*/
	var hasScrollbar = window.innerWidth > document.documentElement.clientWidth;
	if (hasScrollbar) {
		//FIXME
	}
	
});