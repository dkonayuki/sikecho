function prepareLoadSubjectPage() {
	// prepare semester table
	var semestersParam = getParameterByName("semesters[]");
	if (semestersParam != null) {
		$("#all-semester").removeClass("active");
		var table = $("#subject-menu-semester");
  	var semesters = table.find("td[data-type=semester]");
  	semesters.each(function() {
  		if ($.inArray($(this).data("id").toString(), semestersParam) != -1) {
  			$(this).addClass("active");
  			var uni_year = table.find("td[data-type=uni_year][data-id=" + $(this).data("parent") + "]");
  			uni_year.addClass("active");
  		}
  	});
	}
	
	// prepare course list
	var coursesParam = getParameterByName("courses[]");
	if (coursesParam != null) {
		$("#all-course").prop("checked", false);
		var list = $("#subject-menu-course");
		var courses = list.find("input[type=checkbox][name=course]");
		courses.each(function() {
			if ($.inArray($(this).val().toString(), coursesParam) != -1) {
				$(this).prop("checked", true);
  			var faculty = $(this).closest("li.faculty-item").find("input[type=checkbox][name=faculty]");
  			faculty.prop("checked", true);
  			faculty.parent().find("ul").show();
			}
		});
	}
	
	//prepare tags list
	var tagsParam = getParameterByName("tags[]");
	if (tagsParam != null) {

		$("#subject-menu-tag button").each(function() {
			if ($.inArray($(this).text(), tagsParam) != -1) {
				$(this).addClass("active");
			}
		});
	}
	
	//prepare day-time
	var dayParam = getParameterByName("day");
	$('select[name=day]').val(dayParam);
	var timeParam = getParameterByName("time");
	$('select[name=time]').val(timeParam);
	$('.selectpicker').selectpicker('refresh');
	
	//filter search is automatically loaded
	//order option is automatically loaded
}

/*For year-semester table*/
$.fn.nestedTable = function () {
  var semesters = $(this).find("td[data-type=semester]");
  var uni_years = $(this).find("td[data-type=uni_year]");

	var table = $(this);
	
	function checkAllYear() {
		    	
  	//select the "all_year" cell
  	var all_year = table.find("#all-semester");
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
  
  //click on all-semester cell
  table.find("#all-semester").on("click", function() {
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

/*For subject list reload*/
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
	$("#subject-menu-semester td[data-type=semester]").each(function() {
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
	if ($("#subject-search #search").val() != "") {
		data.search = $("#subject-search #search").val();
	}
	
	//check if order option is needed
	data.order = $("#subject-order-option select.selectpicker option:selected").val();
	
	//check if day/time select changed
	data.day = $("#subject-day select.selectpicker option:selected").val();
	data.time = $("#subject-time select.selectpicker option:selected").val();
	
	//get /subjects, execute as script
	//use current locale
	$.ajax({
		url: "/" + I18n["meta"]["code"] + "/subjects",
		data: data,
		dataType: "script",
		contentType: "application/json"
	});
	
	//replace current url, compatiable with turbolinks
  window.history.replaceState({ turbolinks: true }, "", "/" + I18n["meta"]["code"] + "/subjects?" + decodeURIComponent($.param(data, false)));
	//for pushState
	//window.history.pushState({ turbolinks: true, position: window.history.state.position + 1 }, '', page_tab);
}

/*Main start here*/
$(document).on("page:load ready", function() {
	$(".subjects.index").ready(function() {
		//prepare first time load
		$('.selectpicker').selectpicker();
		prepareLoadSubjectPage();

		/*initiate nested checkbox list*/
		$("#subject-menu-course").nestedCheckbox();
		
		/*For tag list*/
		$("#subject-menu-tag button").on("click", function() {
			$(this).toggleClass("active");
			reloadSubjectList();
		});
		
		/*initiate nested table*/
		$("#subject-menu-semester").nestedTable();
		
	 	/*For subject order option*/
		$('#subject-order-option .selectpicker').on("change", function () {
    	reloadSubjectList();
		});
	 	
	 	/*For live search*/
 		var timeout; // add delay time
		$("#subject-search input").keyup(function() {
			window.clearTimeout(timeout); //clear delay
	    timeout = window.setTimeout(reloadSubjectList, 500);
			return false;
		});

		/*For dynamic schedule add btn*/
		$("#subjects-list").on("click", ".subject-menu-line a", function() {
			
			var href = $(this).attr("href");
			var dataMethod = $(this).data("method");
			var subjectName = $(this).parents(".subject-item-line").data("name");
			var subjectID = $(this).parents(".subject-item-line").data("id");
			var imgPath = $(this).parents(".subject-item-line").data("img");
			
			/*Trigger magnific popup*/
			$.magnificPopup.open({
				showCloseBtn: false,
			  removalDelay: 300,
			  items: {
		      src: dataMethod == "post" ? '#subject-schedule-register' : '#subject-schedule-remove',
		      type: 'inline'
			  },
			  mainClass: "mfp-zoom-in",
			  callbacks: {
		  		open: function() {
				    $(".skc-modal").off().on("click", "a", function() {
				    	
				    	// when user clicks on ok
				    	if ($(this).data("skc-confirm") == "ok") {
				    		$.ajax({
									url: href,
									type: dataMethod,
									dataType: "json",
									success: function(msg) {
										if (msg.status == "ok") {
											//need to get script in order to reload appropriate subject item
											$.getScript("/" + I18n["meta"]["code"] + "/subjects/reload/" + subjectID, null);
						
											//Set notification depends on the button user clicked on
											if (dataMethod == "post") {
												$.gritter.add({
													title: subjectName,
													text: I18n["subject_register_notification"],
													image: imgPath,
													sticky: false, 
													time: 5000,
												});
											} else {
												$.gritter.add({
													title: subjectName,
													text: I18n["subject_remove_notification"],
													image: imgPath,
													sticky: false, 
													time: 5000,
												});
											}
										} else {
											// error from server
											$.gritter.add({
												title: subjectName,
												text: I18n["error"],
												image: imgPath,
												sticky: false, 
												time: 5000,
											});
										}
					
									}
								});
				    	}
				    	
				    	// close popup after btn click
				    	$.magnificPopup.close();
				    	// prevent default link
				    	return false;
				    });
				  }
				}
			});
			
			return false;
		});
		
		/*For day/time select*/
		$('#subject-menu-week .selectpicker').on("change", function () {
    	reloadSubjectList();
		});
		
		/*For endless page*/
		if ($(".hidden-pagination").length) {
			$(window).scroll(function(){
				url = $(".next a").attr("href");
				//need url so it won't be called multiple times
		    if (url && ($(window).scrollTop() > $(document).height() - $(window).height() - 50)) {
		    	//disable pagination link
		    	$(".pagination").text("fetching...");

		    	//append loading.gif
	  			$('#subjects-list').append("<div id='loading'><img src='/assets/loading.gif'></div>");
					$.getScript(url);
		    }
			});
		}
		
		/*binding the ok btn*/
		$("#subject-menu-close").on("click", function() {
			$.magnificPopup.close(); // Close popup that is currently opened (shorthand)
		});
		
		/*Trigger magnific popup*/
		$('#subject-filter-trigger').magnificPopup({
		  removalDelay: 300,
		  items: {
		      src: '#subject-menu-right',
		      type: 'inline'
		  },
		  mainClass: "mfp-ltr",
		  callbacks: {
			  beforeOpen: function() {
			  	$("#subject-menu-right").removeClass().addClass("mfp-hide");
			  	$("#subject-menu-close").css("display", "inline-block");
			  },
		    afterClose: function() {
			  	$("#subject-menu-right").removeClass().addClass("col-sm-3 col-xs-12 hidden-xs pull-right");
			  	$("#subject-menu-close").css("display", "none");
			  },
			}
		});


	}); //end of ready
});