$(document).on("page:change", function() {
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
		$(".outline-btn").off("click").on("click", function() {
			$.ajax({
			  url: this.href,
			  dataType: "script",
			  success: function() {
			  	ajaxSuccess();
			  	scrollToAnchor("notes");
			  }
			});
			return false;
		});
		
		/*For schedule add btn in show subject page*/
		/*Need selector on a to ensure binding on dynamically elements */
		$("#show-subject-schedule").off("click").on("click", "a", function() {
			var href = $(this).attr("href");
			var dataMethod = $(this).attr("data-method");
			var subjectName = $("#show-subject-schedule").data("name");
			var subjectID = $("#show-subject-schedule").data("id");
			var imgPath = $("#show-subject-schedule").data("img");
			
			$.ajax({
				url: href,
				type: dataMethod,
				dataType: "script",
				success: function() {
					//need to get script in order to refresh menu
					$.getScript("/subjects/" + subjectID, null);

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
		
		$(".owl-carousel").owlCarousel({
			items : 4,
	    itemsDesktop : [1199,3],
	    itemsDesktopSmall : [980,2],
	    itemsTablet: [768,2],
	    itemsTabletSmall: false,
	    itemsMobile : [479,1],
			navigation:true,
	    navigationText: [
	      "<span class='glyphicon glyphicon-chevron-left'></span>",
	      "<span class='glyphicon glyphicon-chevron-right'></span>"
	      ],
		});
		
	});//end of ready function
});