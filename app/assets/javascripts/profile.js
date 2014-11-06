$(document).on("page:load ready", function() {
	$(".registrations.edit").ready(function() {
		
		//delete education
		$(".education-delete").on("click", function() {
			// delete button: id of education -> data-id
			// select tag: id of education -> value
			
			var answer = confirm(I18n["delete_confirm"]);
			if (answer) {
				var data;
				var currentEducation = $("input[name='current'][checked='checked']");
				var newCurrentEducation;
				
				//get new education if user delete the current education
				if (currentEducation.attr("value") == $(this).attr("data-id")) {
					//new education will be the last education that is not the current education
					newCurrentEducation = $("input[name='current'][value!=" + $(this).attr("data-id") + "]:last");
					data = "new_education_id=" + newCurrentEducation.attr('value');
				}
				$.ajax({
					url: $(this).attr("href"),
					dataType: "script",
					data: data,
					type: $(this).attr("data-method"),
					success: function() {
						if (newCurrentEducation) {
							//set the new Education checked
							newCurrentEducation.attr('checked', true);
						}
					}
				});
			}
			return false;
		});
	
		/*For ajax education popup in profile*/	
	  $('.education-popup').magnificPopup({
		  type: 'ajax',
		  removalDelay: 300,
		  mainClass: 'mfp-zoom-in',
	    callbacks: {
	   		parseAjax: function( mfpResponse ) {
	        mfpResponse.data = $(mfpResponse.data).find('#education-edit');
			  },
		    ajaxContentAdded: function() {
			    // Ajax content is loaded and appended to DOM
					prepareEducations();
			  }
			}
		});	
		
	});//end of ready function
});