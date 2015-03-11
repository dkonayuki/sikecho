$(document).on("page:load ready", function() {

	$(".subjects.edit, .subjects.new, .subjects.create, .subjects.update").ready(function() {

		$('.selectpicker').selectpicker();

		$("#subject-description").wysihtml5({locale: I18n["meta"]["code_country"]});
		var tags;		
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
		    	case I18n["seminar"]: return 'label label-primary';
		      case I18n["all_year"]: return 'label label-warning';
		      case I18n["intensive_course"]: return 'label label-success';
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
		// however since rails using RESTFUL, update page has different url, so we need to specific the url
		if ($(".subjects").hasClass("edit") || $(".subjects").hasClass("update")) {
			$.getJSON("/subjects/" + $("#subject-edit").data("id") + "/tags.json", function(data, status) {
			  $.each(data, function( key, val ) {
			    $('.tag-input').tagsinput('add', val);
			  });
			});
		}
		
		//turn on inline mode
		$.fn.editable.defaults.mode = 'inline';
		$.fn.editable.defaults.ajaxOptions = {dataType: 'json', type: "PUT"};
		
		var subjectID = $("#subject-edit").data("id");

		function enableInlineEdit() {
			//edit inline
			$('.outline-date').editable({
		    format: 'yyyy-mm-dd', //format of value; add data-viewformat if viewformat is difference
		    datepicker: {
		    	language: I18n["meta"]["code"] //translations
		    },
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

		$('#subject_uni_year_id').on("change", change_uni_year);
		//first time
		change_uni_year();

		/*for anchor*/
		var anchor = window.location.hash.replace("#", "");
		if (anchor != "") {
			scrollToAnchor(anchor);
		}

		/*Disable add btn when outline number is 30*/
		var val = parseInt($('#number-of-outlines-select').val());
		if (val == 30) {
			$("#new-auto-outline").attr("disabled", true);
		}
		
		/*Change outline number*/
		$('#number-of-outlines-select').on("change", function() {
			var val = parseInt($('#number-of-outlines-select').val());
			$.ajax({
			  url: $(this).data("link"),
			  data: "number_of_outlines=" + $(this).val(),
			  dataType: "script",
			  success: function() {
	  			//edit inline
					enableInlineEdit();
					if (val < 30) {
						$("#new-auto-outline").attr("disabled", false);
					} else if (val == 30) {
						$("#new-auto-outline").attr("disabled", true);
					}
			  }
			});
		});
		
		/*create new outline*/
		$("#new-auto-outline").on("click", function() {
			var val = parseInt($('#number-of-outlines-select').val());
			
			if (val < 30) {
				$.ajax({
					url: $(this).attr("href"),
					dataType: "script",
					type: "post",
		      complete: function() {
		  			//edit inline
						enableInlineEdit();
						val++;
						$('#number-of-outlines-select').val(val);
						$('.selectpicker').selectpicker("refresh");
						if (val == 30) {
							$("#new-auto-outline").attr("disabled", true);
						}
	    		}
				});
			}

			return false;
		});
		
		//edit inline
		enableInlineEdit();
		
		/*For schedule table*/
		//add old periods if exist
		if ($(".subjects").hasClass("edit") || $(".subjects").hasClass("update")) {
				$.getJSON("/subjects/" + $("#subject-edit").data("id") + "/periods.json", function(data, status) {
			  $.each(data, function( key, val ) {
			  	$("#subject-table .cell[data-day='" + val.day + "'][data-time='" + val.time + "']").addClass("active");
	  			$("#subject-table").append("<input id='periods' multiple='true' name='periods[]' type='hidden' value=" + [val.day, val.time] + ">");
			  });
			});
		}
	
		//add btn
		$("#subject-table").on("click", ".cell .subject-table-add", function() {
			var cell = $(this).parent();
			$("#subject-table").append("<input id='periods' multiple='true' name='periods[]' type='hidden' value=" + [cell.data("day"), cell.data("time")] + ">");
			cell.addClass("active");
		});
		
		//remove btn
		$("#subject-table").on("click", ".cell.active .subject-table-remove", function() {
			var cell = $(this).parent();
			$("#subject-table input[value='" + [cell.data("day"), cell.data("time")] + "']").remove();
			cell.removeClass("active");
		});
		
		//change remove_picture if needed
		$("#subject-edit .fileinput").on("change.bs.fileinput", function() {
			$("#subject-edit #remove-picture").val("0");
		});
		
		$("#subject-edit .fileinput").on("clear.bs.fileinput", function() {
			$("#subject-edit #remove-picture").val("1");
		});
			
	});//end of ready function
});