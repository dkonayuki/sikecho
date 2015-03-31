function prepareUserEdit() {
	//delete education
	$("#user-edit").off().on("click", ".education-delete", function() {
		// delete button: id of education -> data-id
		// select tag: id of education -> value
		
		var answer = confirm(I18n["delete_confirm"]);
		if (answer) {
			var data;
			var deleteEducationID = $(this).data("id");
			var currentEducationID = $("#education-table table").data("current");
			var newCurrentEducation;
			
			//get new education if user delete the current education
			if (currentEducationID == deleteEducationID) {
				//new education will be the last education that is not the current education
				newCurrentEducation = $("input[name='current_education'][value!=" + deleteEducationID + "]:last");
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
  $(".education-edit-popup").magnificPopup({
	  type: "ajax",
	  removalDelay: 300,
	  mainClass: "mfp-zoom-in",
    callbacks: {
   		parseAjax: function( mfpResponse ) {
        mfpResponse.data = $(mfpResponse.data).find("#education-edit");
		  },
	    ajaxContentAdded: function() {
		    // Ajax content is loaded and appended to DOM
				prepareEducations();
		  }
		}
	});
	
	/*For ajax education popup in profile*/	
  $(".education-new-popup").magnificPopup({
	  type: "ajax",
	  removalDelay: 300,
	  mainClass: "mfp-zoom-in",
    callbacks: {
   		parseAjax: function( mfpResponse ) {
        mfpResponse.data = $(mfpResponse.data).find("#education-edit");
		  },
	    ajaxContentAdded: function() {
		    // Ajax content is loaded and appended to DOM
				prepareEducations();
				
				//run change univeresity first time in new form
				change_university();
		  }
		}
	});
}

$(document).on("page:load ready", function() {
	$(".registrations.edit").ready(function() {
		
		prepareUserEdit();
		
		//change remove_avatar if needed
		$("#user-edit .fileinput").on("change.bs.fileinput", function() {
			$("#user-edit #remove-avatar").val("0");
		});
		
		$("#user-edit .fileinput").on("clear.bs.fileinput", function() {
			$("#user-edit #remove-avatar").val("1");
		});
		
		// make sure education-public param is submitted even when not checked
		// by making a hidden input and change it's value
		// because 0 or false will not be passed to controller
		$("#education-public").change(function() {
	  	$("#education-switch input[type=hidden]").val($(this).is(":checked") == true ? 1 : 0);
	  	$(this).val($(this).is(":checked") == true ? 1 : 0);
		});
		
	});//end of ready function
});