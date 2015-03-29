function prepareUniversityEdit() {
			
	var id = $("#university-edit").data("id");
	
	/*create teacher popup*/	
  $("#teacher-popup").magnificPopup({
	  type: "ajax",
	  removalDelay: 300,
	  mainClass: "mfp-zoom-in",
	  showCloseBtn: true,
    callbacks: {
   		parseAjax: function( mfpResponse ) {
        mfpResponse.data = $(mfpResponse.data).find("#teacher-edit");
		  },
	    ajaxContentAdded: function() {
		    // Ajax content is loaded and appended to DOM
				prepareTeacherEdit();
				
				//close popup after submit
				$(".teacher-form").on("submit", function() {
					$.ajax({
						url: $(this).attr("action"),
						data: $(this).serialize(),
						type: "post",
						success: function() {
							//TODO need to check for errors when create a new teacher
							
							//close popup after submit
							$.magnificPopup.close();
							
							//reload teacher list
							$.getScript("/universities/" + id + "/reload");
						}
					});
					return false;
				});
		  }
		}
	});
}

$(document).on("page:load ready", function() {
	$(".universities.edit, .universities.new, .universities.create, .universities.update").ready(function() {
		
		prepareTeacherIndex();
		prepareUniversityEdit();
		
		$(".selectpicker").selectpicker();
		
		//change remove_log if needed
		$("#uni-logo-fileinput").on("change.bs.fileinput", function() {
			$("#uni-logo-fileinput #remove-logo").val("0");
		});
		
		$("#uni-logo-fileinput").on("clear.bs.fileinput", function() {
			$("#uni-logo-fileinput #remove-logo").val("1");
		});
		
		//change remove_picture if needed
		$("#uni-picture-fileinput").on("change.bs.fileinput", function() {
			$("#uni-picture-fileinput #remove-picture").val("0");
		});
		
		$("#uni-picture-fileinput").on("clear.bs.fileinput", function() {
			$("#uni-picture-fileinput #remove-picture").val("1");
		});

	});//end of ready function
});