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
//= require turbolinks
//= require bootstrap
//= require bootstrap-select.js
//= require bootstrap-tagsinput.js
//= require handlebars.js
//= require typeahead.bundle.js
//= require wysihtml5
//= require bootstrap-editable
//= require jquery-fileupload
//= require jquery.ui.all
//= require jquery.magnific-popup.js
//= require jquery.autosize
//= require owl.carousel.js
//= require fileinput.js
//= require masonry.pkgd.js
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

 	/*For filter menu active*/
 	$(".filter-menu li a").off("click").on("click", function() {
		$.getScript(this.href, ajaxSuccess); 
  	$(".filter-menu li a").each(function() {
  		$(this).removeClass( "active" );
  	});
  	$(this).addClass("active");
  	$(".filter-form input").val("");
	  return false;
	});
	
	/*For fixed subject menu*/
	if ($(".fixed-menu").length) {
		var fixedMenuOffset = $(".fixed-menu").offset();
		$(window).scroll(function(){
      if($(window).scrollTop() > fixedMenuOffset.top - 20){
          $(".fixed-menu").css('position','fixed').css('top','0');
      } else {
          $(".fixed-menu").css('position','static');
      }    
		});		
	}
	
	/*For subject menu*/
	function reloadSubjectList() {
		var data;
		$("input[name=course][checked=checked]").each(function() {
			console.log($(this).attr("value"));
		});
		/*$.ajax({
			url: "/subjects",
			data: data,
			dataType: "script"
		});*/
	}
	
	$("#subject-menu-right input[type=checkbox]").change(function() {
		cb = $(this);
  	cb.attr("checked", cb.prop("checked"));
		reloadSubjectList();
	});
	
	/*For live search*/
	var timeout; // add delay time
	$("#filter-subject input").keyup(function() {
		window.clearTimeout(timeout); //clear delay
		var data = $("#filter-subject").serialize() + "&filter=" + $(".filter-menu .active").text();
    timeout = window.setTimeout(function(){ //set a new delay, after an amount of time, ajax function will be called
		  $.ajax({
			  url: $("#filter-subject").attr("action"),
			  data: data, //default contenttype is url text
			  success: null,
			  dataType: "script"
			});    
		}, 500);

		return false;
	});
  
  $("#filter-note input").keyup(function() {
		window.clearTimeout(timeout); //clear delay
    timeout = window.setTimeout(function(){ //set a new delay, after an amount of time, ajax function will be called
		  $.ajax({
			  url: $("#filter-note").attr("action"),
			  data: $("#filter-note").serialize() + "&filter=" + $(".filter-menu .active").text(), //default contenttype is url text
			  success: ajaxSuccess,
			  dataType: "script"
			});    
		}, 500);

		return false;
  });
  
  $("#filter-schedule input").keyup(function() {
		window.clearTimeout(timeout); //clear delay
    timeout = window.setTimeout(function(){ //set a new delay, after an amount of time, ajax function will be called
		  $.ajax({
			  url: $("#filter-schedule").attr("action"),
			  data: $("#filter-schedule").serialize(), //default contenttype is url text
			  success: ajaxSuccess,
			  dataType: "script"
			});    
		}, 500);

		return false;
  });
  
  // disable enter key in filter form
  $(".filter-form").on("submit", function() {
		return false; 
  });
  
  /*For note order option*/
 	$("#note-order-option button").on("click", function() {
 		$("#note-order-option button").each(function() {
 			$(this).removeClass("active");
 		});
 		$(this).addClass("active");
 		var data = "filter=" + $(".filter-menu .active").text() + "&order=" + $(this).data("type");
 		if ($("#filter-note #search").val() != "") {
 			data += "&search=" + $("#filter-note #search").val();
 		}
	  $.ajax({
		  url: "/notes",
		  data: data ,//default contenttype is url text
		  success: ajaxSuccess,
		  dataType: "script"
		});    
 	});
 	
 	/*For subject order option*/
 	$("#subject-order-option button").on("click", function() {
 		$("#subject-order-option button").each(function() {
 			$(this).removeClass("active");
 		});
 		$(this).addClass("active");
		var data = "filter=" + $(".filter-menu .active").text() + "&style=" + $(this).data("type");
		if ($("#filter-subject #search").val() != "") {
			data += "&search=" + $("#filter-subject #search").val();
		}
	  $.ajax({
		  url: $("#filter-subject").attr("action"),
		  data: data ,//default contenttype is url text
		  success: null,
		  dataType: "script"
		});  
 	});
	
	/*For edit subject form*/
	$("#subject-edit").on("click", ".remove_fields", function() {
		$(this).prev("input[type=hidden]").val("1");
		$(this).closest("fieldset").hide();
		return false;
	});
	$("#subject-edit").on("click", ".add_fields", function() {
		//need to generate unique id
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    //Refresh selectpicker
		$('.selectpicker').selectpicker('refresh');
		return false;
	});
	
	/*For edit user form*/
	$("#user-edit").on("click", ".remove_fields", function() {
		$(this).prev("input[type=hidden]").val("1");
		$(this).closest("fieldset").hide();
		return false;
	});
	$("#user-edit").on("click", ".add_fields", function() {
		//need to generate unique id
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    //Refresh selectpicker
		$('.selectpicker').selectpicker('refresh');
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
	
	/*For endless page*/
	if ($(".hidden-pagination").length) {
		$(window).scroll(function(){
			url = $(".next a").attr("href");
	    if (url && ($(window).scrollTop() > $(document).height() - $(window).height() - 50)) {
	    	//disable pagination link
	    	$(".pagination").text("fetching...");
	    	//append loading.gif
	  		if ($("#subjects-list").length) {
	  			$('#subjects-list').append("<div id='loading'><img src='/assets/loading.gif'></div>");
	  		}
	  		if ($("#notes-list").length) {
	  			$('#notes-list').append("<div id='loading'><img src='/assets/loading.gif'></div>");
	  		}
				$.getScript(url);
	    }   
		});	
	}

});