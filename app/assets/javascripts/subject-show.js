$(document).on("page:load ready", function() {
	$(".subjects.show").ready(function() {
		
		/*for anchor*/
		$("#show-subject-overview a").on("click", function() {
			var anchor = $(this).attr("href").replace("#",""); 
			// the difference between this.href and jquery attr("href")
			// $(this).attr("href") == #notes 
			// this.href == http://localhost:8000/subjects/11#description 
			scrollToAnchor(anchor);
			return false;
		});
		
		/*For outline btn*/
		$(".outline-btn").on("click", function() {
			$.ajax({
			  url: $(this).attr("href"),
			  dataType: "script",
			  success: function() {
			  	ajaxSuccess();
			  	scrollToAnchor("notes");
			  }
			});
			return false;
		});
		
		/*overview menu will change to absolute position when scroll to bottom*/
    var menu = $("#show-subject-menu");
    $(window).scroll(function () {
    var scrollBottom = $(document).height() - $("#show-subject-menu").innerHeight() - $(window).scrollTop();
      if (scrollBottom > 51 + 50 + 20) { // header: 51, footer: 50, margin from bottom: 20
      	menu.removeClass("menu-absolute");
      } else {
      	menu.addClass("menu-absolute");
      }
    });
		
		/*For schedule add btn in show subject page*/
		/*Need selector on a to ensure binding on dynamically elements */
		$("#show-subject-schedule").add("#show-subject-schedule-mobile").on("click", "a", function() {
			var href = $(this).attr("href");
			var dataMethod = $(this).attr("data-method");
			var subjectName = $("#show-subject-schedule").data("name");
			var subjectID = $("#show-subject-schedule").data("id");
			var imgPath = $("#show-subject-schedule").data("img");
			
			$.ajax({
				url: href,
				type: dataMethod,
				dataType: "json",
				success: function(msg) {
					if (msg.status == "ok") {
						//need to get script in order to refresh menu
						$.getScript("/" + I18n["meta"]["code"] + "/subjects/" + subjectID, null);
	
						//Set notification
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
			return false;
		});
		
		//for recommender subjects
		$(".owl-carousel").owlCarousel({
			items : 3,
	    itemsDesktop : [1199,2],
	    itemsDesktopSmall : [980,2],
	    itemsTablet: [768,2],
	    itemsTabletSmall: false,
	    itemsMobile : [479,1],
			navigation: true,
			pagination: false,
	    navigationText: [
	      "<span class='glyphicon glyphicon-chevron-left'></span>",
	      "<span class='glyphicon glyphicon-chevron-right'></span>"
	      ],
		});

	});//end of ready function
});