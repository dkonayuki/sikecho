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
//= require_tree .
	
$(document).ready(function() {

});
	
$(document).on("page:change", function() {

 	/*For filter menu active*/
 	$("#filter-menu li a").off("click").on("click", function() {
 		if ($(this).attr("id") == "sub-menu-trigger") {
 			$("#sub-filter-bar").toggle();
 		}
 		else {
 			$.getScript(this.href, null); 
	 		/* equal to : $.ajax({
			  url: url,
			  dataType: "script",
			  success: success
			}); */
	  	$("#filter-menu li a").each(function() {
	  		$( this ).removeClass( "active" );
	  	});
	  	$("#sub-filter-bar li a").each(function() {
  			$( this ).removeClass( "active" );
  		});
	  	$(this).addClass("active");
	  	$("#filter-form input").val("");
	  	$("#sub-filter-bar").hide();
 		}
	  return false;
	});
	
 	/*For sub filter menu active*/
 	$("#sub-filter-bar li a").off("click").on("click", function() {
 		$.getScript(this.href, null); 
 		/* equal to : $.ajax({
		  url: url,
		  dataType: "script",
		  success: success
		}); */
		$("#filter-menu li a").each(function() {
	  		$( this ).removeClass( "active" );
	  	});
  	$("#sub-filter-bar li a").each(function() {
  		$( this ).removeClass( "active" );
  	});
  	$(this).addClass("active");
		$("#sub-menu-trigger").addClass("active");
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
	if ($("#show-subject-menu-content").length) {
		var fixedMenuOffset = $("#show-subject-menu-content").offset();
		$(window).scroll(function(){
	        if($(window).scrollTop() > fixedMenuOffset.top - 20){
	            $("#show-subject-menu-content").css('position','fixed').css('top','0');
	        } else {
	            $("#show-subject-menu-content").css('position','static');
	        }    
		});		
	}

	/*For outline btn*/
	$(".outline-btn").off("click").on("click", function() {
		$.ajax({
		  url: this.href,
		  dataType: "script",
		  success: scrollToAnchor("notes")
		});
		return false;
	});
	
	/*For live search*/
	$("#filter-form input").keyup(function() {
	  $.ajax({
		  url: $("#filter-form").attr("action"),
		  data: $("#filter-form").serialize() + "&filter=" + $("#filter-menu .active").text(), //default contenttype is url text
		  success: null,
		  dataType: "script"
		});
		return false;
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
	
	/*For typeahead*/
	var searchSource = function(query, cb) {
	
	  var results = [];
	  var subject_item = new Object();
	  subject_item.value = "授業検索: " + "'" + query + "'";
	  subject_item.url = "/subjects?search=" + query;
	  results.push(subject_item);
	  var note_item = new Object();
	  note_item.value = "ノート検索: " + "'" + query + "'";
	  note_item.url = "/notes?search=" + query;
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

});