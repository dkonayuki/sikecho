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
//= require_tree .
	  
/*MaxWidth for ajax popup*/
function setMaxWidth() {
	if ($(window).width() >= 768) {
		if ($("#document-content").length) {
			$("#document-content").css("maxWidth", ( $("#show-document").width() - $("#document-comment-section").width() - 30 ) + "px"); //30 for scroolbar				
		}
	}
	if ($(".note-item").length) {
		$(".note-title").css("maxWidth", ( $('.note-item').width() - $('.note-thumbnail').outerWidth(true) - 1 ) + "px" ); //outerWidth(true): include margin
		$(".note-tags").css("maxWidth", ( $('.note-item').width() - $('.note-thumbnail').outerWidth(true) - $('.note-view').width() - 1 ) + "px" );
	}
}

/*Define after ajax success*/
function ajaxSuccess() {
	/*For note dynamic max width*/
  setMaxWidth();
	$( window ).on( "resize", setMaxWidth ); //Remove this if it's not needed. It will react when window changes size.
	
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
 		if ($(this).attr("id") == "sub-menu-trigger") {
 			$("#sub-filter-bar").toggle();
 		}
 		else {
 			$.getScript(this.href, ajaxSuccess); 
	  	$(".filter-menu li a").each(function() {
	  		$(this).removeClass( "active" );
	  	});
	  	$("#sub-filter-bar li a").each(function() {
  			$(this).removeClass( "active" );
  		});
	  	$(this).addClass("active");
	  	$(".filter-form input").val("");
	  	$("#sub-filter-bar").hide();
 		}
	  return false;
	});
	
 	/*For sub filter menu active*/
 	$("#sub-filter-bar li a").off("click").on("click", function() {
 		$.getScript(this.href, function() {
			//load more items if needed
			$(window).scroll();		 			
 		}); 
		$(".filter-menu li a").each(function() {
  		$(this).removeClass("active");
  	});
  	$("#sub-filter-bar li a").each(function() {
  		$(this).removeClass("active");
  	});
  	$(this).addClass("active");
		$("#sub-menu-trigger").addClass("active");
  	$(".filter-form input").val("");
  	$("#sub-filter-bar").hide();
  	return false;
	});
	
	/*for anchor*/
	function scrollToAnchor(aid){
    var aTag = $("a[name='"+ aid +"']");
    $("html,body").animate({scrollTop: aTag.offset().top},"fast");
	}
	$("#show-subject-overview a").on("click", function() {
		var anchor = $(this).attr("href").replace("#",""); 
		// the difference between this.href and jquery attr("href")
		// $(this).attr("href") == #notes 
		// this.href == http://localhost:8000/subjects/11#description 
		scrollToAnchor(anchor);
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

	/*For outline btn*/
	$(".outline-btn").off("click").on("click", function() {
		$.ajax({
		  url: this.href,
		  dataType: "script",
		  success: function() {
		  	ajaxSuccess();
		  	scrollToAnchor("notes");
		  }
		});
		return false;
	});
	
	/*For live search*/
	var timeout; // add delay time
	$("#filter-subject input").keyup(function() {
		window.clearTimeout(timeout); //clear delay
		var data = $("#filter-subject").serialize() + "&filter=" + $(".filter-menu .active").text();
		if ($("#sub-filter-bar .active").length) {
			data += "&semester=" + $("#sub-filter-bar .active").data("id");
		}
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
		if ($("#sub-filter-bar .active").length) {
			data += "&semester=" + $("#sub-filter-bar .active").data("id");
		}
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

	/*For search bar slide*/
  $(".search-bar-slide input").focus(function() {
  	$(this).animate({
  		width : "+=70px"		
  	}, 200);
  });
  
  $(".search-bar-slide input").focusout(function() {
  	$(this).animate({
  		width : "-=70px"		
  	}, 200);
  });
  
  /*For search bar submit*/
  $(".search-bar").on("submit", function(){
  	window.location.href = "/search?query=" + $(this).find("#query").val() + "&type=授業";
  	return false;
  });
	
	/*For typeahead*/
	var searchSource = function(query, cb) {
	  var results = [];
	  var subject_item = new Object();
	  subject_item.value = "授業検索: " + "'" + query + "'";
	  subject_item.url = "/search?query=" + query + "&type=授業";
	  results.push(subject_item);
	  var note_item = new Object();
	  note_item.value = "ノート検索: " + "'" + query + "'";
	  note_item.url = "/search?query=" + query + "&type=ノート";
	  results.push(note_item);
	  cb(results);
	};
	
	$(".typeahead").typeahead("destroy");
	$(".typeahead").typeahead(null, {
	  displayKey: "value",
	  source: searchSource,
	  templates: {
	    suggestion: Handlebars.compile(
	      "<p><strong>{{value}}</strong></p>"
	    )
	  }
	});
	$(".typeahead").on("typeahead:selected", function(event, item) {
		window.location.href = item.url;
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
  $('.ajax-popup-link').magnificPopup({
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