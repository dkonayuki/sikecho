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
//= require bootstrap-select
//= require bootstrap-editable/bootstrap-editable
//= require bootstrap-tagsinput
//= require typeahead.min.js
//= require moment.min.js
//= require wysihtml5/wysihtml5-0.3.0.js
//= require wysihtml5/handlebars.runtime.min.js
//= require wysihtml5/templates.js
//= require wysihtml5/bootstrap3-wysihtml5.js
//= require wysihtml5/bootstrap-wysihtml5.en-US.js
//= require wysihtml5/commands.js
//= require bootstrap-editable/wysihtml5
//= require jquery-fileupload
//= require_tree .

	
$(document).ready(function() {

});

$(document).on('page:change', function() { 
  
 	/*For filter menu active*/
 	$('#filter-menu li a').on('click', function() {
 		if ($(this).attr('id') == 'sub-menu-trigger') {
 			$('#sub-filter-bar').toggle();
 			$('#filter-menu li a').each(function() {
	  		$( this ).removeClass( "active" );
	  	});
	  	$(this).addClass("active");
 		}
 		else {
 			$.getScript(this.href, null); 
	 		/* equal to : $.ajax({
			  url: url,
			  dataType: "script",
			  success: success
			}); */
	  	$('#filter-menu li a').each(function() {
	  		$( this ).removeClass( "active" );
	  	});
	  	$(this).addClass("active");
	  	$("#filter-form input").val("");
	  	$('#sub-filter-bar').hide();
 		}
	  return false;
	});
	
 	/*For sub filter menu active*/
 	$('#sub-filter-bar li a').on('click', function() {
 		$.getScript(this.href, null); 
 		/* equal to : $.ajax({
		  url: url,
		  dataType: "script",
		  success: success
		}); */
  	$('#sub-filter-bar li a').each(function() {
  		$( this ).removeClass( "active" );
  	});
  	$(this).addClass("active");
  	$('#sub-filter-bar').hide();
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
});