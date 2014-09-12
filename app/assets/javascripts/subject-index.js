$(document).on("page:change", function() {
	$(".subjects.index").ready(function() {

		/*For subject list*/
		function reloadSubjectList() {
			var data = new Object();
			
			//get all active tags 
			var tags = [];
			$("#subject-menu-tag button").each(function() {
				if ($(this).hasClass("active")) {
					tags.push($(this).text());
				}
			});
			data.tags = tags;
			
			//get all checked semesters
			var semesters = [];
			$("#subject-menu-year td[data-type=semester]").each(function() {
				if ($(this).hasClass("active")) {
					semesters.push($(this).data("id"));
				}
			});
			data.semesters = semesters;
			
			//get all checked courses
			var courses = [];
			$("#subject-menu-course input[type=checkbox][name=course]").each(function() {
				if ($(this).is(":checked")) {
					courses.push($(this).val());
				}
			});
			data.courses = courses;
			
			//check if search query is needed
			if ($("#filter-subject #search").val() != "") {
				data.search = $("#filter-subject #search").val();
			}
			
			//check if order option is needed
			$("#subject-order-option button").each(function() {
				if ($(this).hasClass("active")) {
					data.style = $(this).data("type");
				}
			});
			
			//get /subjects, execute as script
			$.ajax({
				url: "/subjects",
				data: data,
				dataType: "script",
				contentType: "application/json"
			});
		}
		
		$.fn.nestedCheckbox = function () {
	    var courses = $(this).find("input[type=checkbox][name=course]");
	    var faculties = $(this).find("input[type=checkbox][name=faculty]");
	
			var mainList = $(this);

			//refresh the all-course box			
			function checkAllCourse() {
	    	//check the "all_course" box
	    	var all_course = mainList.find("#all-course");
	    	var anyBoxChecked = mainList.find("input[type=checkbox][name=faculty], input[type=checkbox][name=course]").is(":checked");

	    	//toggle check for all_course box
	    	all_course.prop("checked", !anyBoxChecked);
			}
	
			//check course box
	    courses.change(function() {
				//select the "parent" faculty
	    	var faculty = $(this).closest("li.faculty-item").find("input[type=checkbox][name=faculty]");
	    	var anySemesterChecked = $(this).closest("ul").find("input[type=checkbox][name=course]").is(":checked");
	    	
	    	//toggle check for faculty box
	    	faculty.prop("checked", anySemesterChecked);
	    	
	    	checkAllCourse();
				reloadSubjectList();
	    });
	    
	    //check faculty box
	    faculties.change(function() {
	    	//toggle courses list
	    	if ($(this).prop("checked")) {
	    		$(this).parent().find("ul").show();
	    	} else {
	    		$(this).parent().find("ul").hide();
	    	}

				//add active class for all of semester if necessary
				$(this).closest("li.faculty-item").find("input[type=checkbox][name=course]").prop("checked", $(this).prop("checked"));
				
	    	checkAllCourse();
				reloadSubjectList();
	    });
	    
	    //check on all-course box
	    mainList.find("#all-course").change(function() {
	    	if ($(this).prop("checked")) {
	    		//checkbox changed from false to true
	    		//remove all checked courses box
	    		mainList.find("input[type=checkbox][name=course], input[type=checkbox][name=faculty]").prop("checked", false);
	    	} else {
	    		//checkbox changed from true to false
	    		//set back to true
	    		$(this).prop("checked", true);
	    		return false;
	    	}
				
				reloadSubjectList();
	    });
	    
	    return $(this);
		};
		
		/*initiate nested checkbox list*/
		$("#subject-menu-course").nestedCheckbox();
		
		/*For tag list*/
		$("#subject-menu-tag button").on("click", function() {
			$(this).toggleClass("active");
			reloadSubjectList();
		});
		
		/*For year-semester table*/
		$.fn.nestedTable = function () {
	    var semesters = $(this).find("td[data-type=semester]");
	    var uni_years = $(this).find("td[data-type=uni_year]");
	
			var table = $(this);
			
			function checkAllYear() {
				    	
	    	//select the "all_year" cell
	    	var all_year = table.find("#all-year");
	    	var anyCellChecked = table.find("td[data-type=uni_year], td[data-type=semester]").hasClass("active");
	    	
	    	//toggle active class for all_year cell
	    	if (anyCellChecked == true) {
	    		all_year.removeClass("active");
	    	} else {
	    		all_year.addClass("active");
	    	}
			}
	
			//click on semester cell
	    semesters.on("click", function() {
	    	//toggle active
				$(this).toggleClass("active");
				
				//select the "parent" uni_year
	    	var uni_year = table.find("td[data-type=uni_year][data-id=" + $(this).data("parent") + "]");
	    	var anySemesterChecked = table.find("td[data-type=semester][data-parent=" + $(this).data("parent") + "]").hasClass("active");
	    	
	    	//add active class if there is any checked semester
	    	if (anySemesterChecked == true) {
	    		uni_year.addClass("active");
	    	} else {
	    		uni_year.removeClass("active");
	    	}
	    	
	    	checkAllYear();
				reloadSubjectList();
	    });
	    
	    //click on year cell
	    uni_years.on("click", function() {
	    	//toggle active
				$(this).toggleClass("active");
	
				//add active class for all of semester if necessary
				if ($(this).hasClass("active")) {
					table.find("td[data-type=semester][data-parent=" + $(this).data("id") + "]").addClass("active");
				} else {
					table.find("td[data-type=semester][data-parent=" + $(this).data("id") + "]").removeClass("active");
				}
				
	    	checkAllYear();
				reloadSubjectList();
	    });
	    
	    //click on all-year cell
	    table.find("#all-year").on("click", function() {
	    	if ($(this).hasClass("active")) {
	    		return false;
	    	} else {
	    		$(this).addClass("active");
	    		//remove all active class
	    		table.find("td[data-type=uni_year], td[data-type=semester]").removeClass("active");
	    	}
				reloadSubjectList();
	    });
	    
	    return $(this);
		};
		
		/*initiate nested table*/
		$("#subject-menu-year").nestedTable();
		
	 	/*For subject order option*/
	 	$("#subject-order-option button").on("click", function() {
	 		$("#subject-order-option button").each(function() {
	 			$(this).removeClass("active");
	 		});
	 		$(this).addClass("active");
			reloadSubjectList();
	 	});
	 	
	 	/*For live search*/
 		var timeout; // add delay time
		$("#filter-subject input").keyup(function() {
			window.clearTimeout(timeout); //clear delay
	    timeout = window.setTimeout(reloadSubjectList, 500);
			return false;
		});

		/*For dynamic schedule add btn*/
		$("#subjects-list").on("click", ".subject-menu-line a", function() {
			var href = $(this).attr("href");
			var dataMethod = $(this).attr("data-method");
			var subjectName = $(this).parent().data("name");
			var imgPath = $(this).parent().data("img");
			
			$.ajax({
				url: href,
				type: dataMethod,
				dataType: "script",
				success: function() {
					//reload subject list
					reloadSubjectList();
					
					//Set notification
					if (dataMethod == "post") {
						$.gritter.add({
							title: subjectName,
							text: 'スケジュールに追加しました。',
							image: imgPath,
							sticky: false, 
							time: 5000,
						});
					} else {
						$.gritter.add({
							title: subjectName,
							text: 'スケジュールから削除しました。',
							image: imgPath,
							sticky: false, 
							time: 5000,
						});
					}
				}
			});
			return false;
		});

	});
});