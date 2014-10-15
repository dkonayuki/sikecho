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
	
	if ($("#filter-note").length) {
		$("#filter-note").css("width", $("#notes").width() - $("#pushmenu-trigger").outerWidth(true) - $("#new-note-btn").outerWidth(true) - 40);
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
  setMaxWidth();
	$(window).on( "resize", setMaxWidth ); //Remove this if it's not needed. It will react when window changes size.

	//load more items if needed
	$(window).scroll();		
}

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

	/*For tooltip*/
	$(".has-tooltip").tooltip({
    'container':'body'
  });
  
});