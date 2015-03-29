function prepareEducations() {
	$(".selectpicker").selectpicker();
	
	//OPTIMIZE need to refactor these functions, or use other approaches if possible
	// code looks ugly
	
	//close popup after submit
	$("#education-form").on("submit", function() {
		$.ajax({
			url: $(this).attr("action"),
			dataType: "script",
			data: $(this).serialize(),
			type: "post",
			success: function() {
				//close popup after submit
				$.magnificPopup.close();
			}
		});
		return false;
	});
	
	function change_university() {
		
		//clear old select
		$('#education_faculty_id').empty();
		$('#education_course_id').empty();
		$('#education_uni_year_id').empty();
		$('#education_semester_id').empty();
		
		var university_id = $("#education_university_id").val();
		
		//get faculties list and refresh select
		$.ajax({
				url: "/faculties_list",	
				data: {university_id: university_id},
				dataType: "json",
				success: function(data) {
					//add new data to faculty select
					$('#education_faculty_id').append("<option value=''></option>");
					$.each(data, function(key, value) {   
				    $('#education_faculty_id')
		          .append($("<option></option>")
		          .attr("value",value.id)
		          .text(value.name));
					});
					//add a blank option for course
					$('#education_course_id').append("<option value=''></option>");
					//refresh select
					$('.selectpicker').selectpicker("refresh");
				}
			}
		);
		
		//get uni_years list and refresh select
		$.ajax({
				url: "/uni_years",	
				data: {university_id: university_id},
				dataType: "json",
				success: function(data) {
					//add new data to uni_year select
					$("#education_uni_year_id").append("<option value=''></option>");
					$.each(data, function(key, value) {   
				    $("#education_uni_year_id")
		          .append($("<option></option>")
		          .attr("value",value.id)
		          .text(value.name));
					});
					//add a blank option for course
					$("#education_semester_id").append("<option value=''></option>");
					//refresh select
					$(".selectpicker").selectpicker("refresh");
				}
			}
		);
	}
	
	function change_faculty() {
		//clear old select
		$('#education_course_id').empty();
		var faculty_id = $("#education_faculty_id").val();
		$.ajax({
				url: "/courses",	
				data: {faculty_id: faculty_id},
				dataType: "json",
				success: function(data) {
					//add new data to course select
					$("#education_course_id").append("<option value=''></option>");
					$.each(data, function(key, value) {   
				    $("#education_course_id")
		          .append($("<option></option>")
		          .attr("value",value.id)
		          .text(value.name));
					});
					$('.selectpicker').selectpicker("refresh");
				}
			}
		);
	}
	
	function change_uni_year() {
		//clear old select
		$('#education_semester_id').empty();
		var uni_year_id = $("#education_uni_year_id").val();
		$.ajax({
				url: "/semesters",	
				data: {uni_year_id: uni_year_id},
				dataType: "json",
				success: function(data) {
					//add new data to semester select
					$.each(data, function(key, value) {   
				    $('#education_semester_id')
		          .append($("<option></option>")
		          .attr("value",value.id)
		          .text(value.name));
					});
					$('.selectpicker').selectpicker("refresh");
				}
			}
		);
	}
	
	$('#education_university_id').on("change", change_university);
	$('#education_faculty_id').on("change", change_faculty);
	$('#education_uni_year_id').on("change", change_uni_year);
}

$(document).on("page:load ready", function() {
	$(".educations.edit, .educations.new, .educations.create, .educations.update").ready(function() {
		prepareEducations();
	});//end of ready function
});