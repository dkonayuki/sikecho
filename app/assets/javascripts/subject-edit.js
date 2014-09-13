$(document).on("page:change", function() {
	$(".subjects.edit, .subjects.new").ready(function() {
		//turn to inline mode
		$.fn.editable.defaults.mode = 'inline';
		$.fn.editable.defaults.ajaxOptions = {dataType: 'json', type: "PUT"};
		
		var subjectID = $("#subject-edit").data("id");
		var oldTags;
		var tags;
		
		function enableInlineEdit() {
			//edit inline
			$('.outline-date').editable({
		    format: 'yyyy-mm-dd', //for sending value
		    name: 'date',
		    url: '/subjects/' + subjectID + '/inline',
		    showbuttons: 'bottom'
			});
			
			$('.outline-content').editable({
		    type: 'textarea',
		    name: 'content',
		    url: '/subjects/' + subjectID + '/inline',
		    showbuttons: 'bottom'
			});
		}
		
		function change_uni_year() {
			var uni_year_id = $("#subject_uni_year_id").val();
			$.ajax({
					url:"/semesters",	
					data:'uni_year_id=' + uni_year_id,
					dataType: "json",
					success: function(data) {
						//clear old select
						$('#subject_semester_id').empty();
						//add new data to semester select
						$.each(data, function(key, value) {   
					    $('#subject_semester_id')
			          .append($("<option></option>")
			          .attr("value",value.id)
			          .text(value.name));
						});
						$('.selectpicker').selectpicker("refresh");
					}
				}
			);
		}
		
		$("#subject-description").wysihtml5({locale: "en-US"});
		$('.selectpicker').selectpicker();
		$('#subject_uni_year_id').on("change", change_uni_year);
		
		// instantiate the bloodhound suggestion engine
		tags = new Bloodhound({
		  datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.name); },
		  queryTokenizer: Bloodhound.tokenizers.whitespace,
		  limit: 5,
		  prefetch: {
		  	ttl: 0,
		    url: '/tags.json', // get tags from application controller
		    filter: function(list) {
		      return $.map(list, function(tag) { return { name: tag.name }; });
		    }
		  }
		});
		 
		// initialize the bloodhound suggestion engine
		tags.initialize();
		
		//initiate tagsinput	
		$('.tag-input').tagsinput({
			tagClass: function(item) {
		    switch (item) {
		    	case 'ゼミ': return 'label label-danger';
		      case '通年': return 'label label-warning';
		      case '集中講義': return 'label label-success';
		      default: return 'label label-info';
		    }
	  	},
			confirmKeys: [13, 9]
		});
	
		$('.tag-input').tagsinput('input').typeahead(null, {
			// instantiate the typeahead UI
			  displayKey: 'name',
	 			source: tags.ttAdapter()
		}).bind('typeahead:selected', $.proxy(function (obj, datum) {  
		  this.tagsinput('add', datum.value);
		  //this.tagsinput('input').typeahead('val','');
		}, $('.tag-input')));
		
		//menu bar
		$('.tag-menu-btn').on('click', function() {
			$('.tag-input').tagsinput('add', this.innerHTML );
		});
		$('#remove-all').on('click', function() {
			$('.tag-input').tagsinput('removeAll');
		});
		
		//fix for left over text
		$('.bootstrap-tagsinput input').blur(function() {
			$(this).val('');
		});
		
		//add old tags if exist
		/*getJSON is equivalent to 
		$.ajax({
		  dataType: "json",
		  url: url,
		  data: data,
		  success: success
		});*/
		// url in ajax syntax: "/tags.json" for absolute url. "tags.json" for relative url.
		$.getJSON('tags.json', function(data) {
  		//oldTags = jQuery.parseJSON(data);
		  $.each( data, function( key, val ) {
		    $('.tag-input').tagsinput('add', val);
		  });
		});
		
		/*for anchor*/
		var anchor = window.location.hash.replace("#", "");
		if (anchor != "") {
			scrollToAnchor(anchor);
		}
		
		$('#number-of-outlines-select').on("change", function() {
			$.ajax({
			  url: $(this).data("link"),
			  data: "number_of_outlines=" + $(this).val(),
			  dataType: "script",
			  success: function() {
	  			//edit inline
					enableInlineEdit();
			  }
			});
		});
		
		//edit inline
		enableInlineEdit();
			
	});//end of ready function
});