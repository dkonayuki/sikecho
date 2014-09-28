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
//= require jquery.ui.all
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
//= require_tree .

/*MaxWidth for ajax popup*/
function setMaxWidth() {
	
	//for desktop page
	if ($(window).width() >= 768) {
		if ($("#document-content").length) {
			$("#document-content").css("maxWidth", ( $("#show-document").width() - $("#document-comment-section").width() - 30 ) + "px"); //30 for scroolbar				
		}
		$("#navbar-collapse-2").css("width", $("#nav-bar").width() - $("#logo").innerWidth() - $("#navbar-collapse-1").width() - $("#navbar-collapse-3 ul").innerWidth() - 60 - 25 + "px");//25 for scroolbar	60 for calendar img and padding			
	}
	
	if ($(".note-item").length) {
		$(".note-title").css("maxWidth", ( $('.note-item').width() - $('.note-thumbnail').outerWidth(true) - 1 ) + "px" ); //outerWidth(true): include margin
		$(".note-tags").css("maxWidth", ( $('.note-item').width() - $('.note-thumbnail').outerWidth(true) - $('.note-view').width() - 1 ) + "px" );
	}
	
	if ($("#filter-subject").length) {
		$("#filter-subject").css("width", $("#subjects-content").width() - $("#new-subject-btn").outerWidth(true) - 40);
	}
}

/*Scroll to anchor*/
function scrollToAnchor(aid){
  var aTag = $("a[name='"+ aid +"']");
  $("html,body").animate({scrollTop: aTag.offset().top},"fast");
}

/*Define after ajax success*/
function ajaxSuccess() {
	/*For note dynamic max width*/
  setMaxWidth();
	$(window).on( "resize", setMaxWidth ); //Remove this if it's not needed. It will react when window changes size.

	//load more items if needed
	$(window).scroll();		
}

function getParameterByName(name) {
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
      results = regex.exec(location.search);
  return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function prepareFirstTime() {
	//first time
	$(window).scroll();	
	
	/*For note dynamic max width first time*/
  setMaxWidth();
	$( window ).on( "resize", setMaxWidth ); //Remove this if it's not needed. It will react when window changes size.		
}

$(document).ready(function() {

});
	
$(document).on("page:change", function() {
	prepareFirstTime();
	
  // disable enter key in filter form
  $(".filter-form").on("submit", function() {
		return false; 
  });

  /*For ajax popup link in show note page*/	
  $('.document-popup').magnificPopup({
	  type: 'ajax',
    callbacks: {
   		parseAjax: function( mfpResponse ) {
        mfpResponse.data = $(mfpResponse.data).find('#show-document');
		  },
	    ajaxContentAdded: function() {
		    // Ajax content is loaded and appended to DOM
				/* auto resize for textarea */
			  $('textarea').autosize();
			  	
				ajaxSuccess();
	
				/*New comment*/
				$("#new-comment-form").on("submit", function() {
					$.ajax({
					  url: $(this).attr("action"),
					  dataType: "script",
					  data: $(this).serialize(),
					  type: "post",
					  success: function() {
					  	$("#comment-content").val("");
					  }
					});
					return false;
				});
				
				/*Remove focus on comment btn*/
				$("#comment-btn").on("click", function() {
					$(this).blur();
				}); 	

		  }
		}
	});

	/*For tooltip*/
	$(".has-tooltip").tooltip();

});