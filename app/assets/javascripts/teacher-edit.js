$(document).on("page:load ready", function() {
	$(".teachers.edit, .teachers.new, .teachers.create, .teachers.update").ready(function() {
		
		$('.selectpicker').selectpicker();
		
		//change remove_picture if needed
		$("#teacher-edit .fileinput").on("change.bs.fileinput", function() {
			$("#teacher-edit #remove-picture").val("0");
		});
		
		$("#teacher-edit .fileinput").on("clear.bs.fileinput", function() {
			$("#teacher-edit #remove-picture").val("1");
		});
		
		//wysihtml5
		$("#teacher-info").wysihtml5({locale: I18n["meta"]["code_country"]});
		
	});//end of ready function
});