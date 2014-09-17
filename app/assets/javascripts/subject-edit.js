$(document).on("page:change", function() {
	$(".subjects.edit, .subjects.new").ready(function() {
		//turn to inline mode
		$.fn.editable.defaults.mode = 'inline';
		$.fn.editable.defaults.ajaxOptions = {dataType: 'json', type: "PUT"};
		
		var subjectID = $("#subject-edit").data("id");

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
		
		$('.selectpicker').selectpicker();
		$('#subject_uni_year_id').on("change", change_uni_year);
		
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