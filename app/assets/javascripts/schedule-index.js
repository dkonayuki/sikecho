$(document).on("page:load ready", function() {
	$(".schedule.index").ready(function() {
		
		//activate draggable on table
		$("#schedule-sub-list").on("mouseover", ".subject-draggable", function() {
		  $(this).draggable({
		    revert: true,
		    revertDuration: 0,
		    stack: ".subject-draggable"
		  });		
		});
		
		
		/*set dropable for schedule table*/
		$("#schedule-table-wrapper").droppable({
			accept: ".subject-draggable",
	    drop: function( event, ui ) {
	    	
	    	//update query and page
	  		var query = $("#filter-schedule #search").val();
				var page = $("#schedule-sub-list ul").data("page");
				
	      $.ajax({
	      	url: "/" + I18n["meta"]["code"] + "/schedule/",
	      	type: "post",
	      	data: {subject_id: ui.draggable[0].getAttribute("data-id"), page: page, search: query },
	      	dataType: "script",
	      });
	    },
	    // period cell will be highlighted during mouse over
	    over: function( event, ui ) {
				$.ajax({
					url: "/subjects/" + ui.draggable[0].getAttribute("data-id") + "/periods",
					dataType: "json",
					success: function(data) {
						$.each(data, function(index, value) {
							$("#schedule-table").find(".cell[data-day='" + value.day + "'][data-time='" + value.time + "']").addClass("hover");
						});
					}
				});
	    },
	    out: function( event, ui ) {
				$("#schedule-table .cell").removeClass("hover");
	    }
		});
		
		/*click on table headers*/
		$("#schedule-table-wrapper").on("click", "#schedule-table th", function() {
			$("#schedule-table th").not(this).removeClass("active");
			$(this).addClass("active");
			
			$.ajax({
				url: "/" + I18n["meta"]["code"] + "/schedule/view_option",
				dataType: "script",
				data: {view_option: $(this).data("day") }
			});
		});
		
		/*click on cell*/
		$("#schedule-table-wrapper").on("click", "#schedule-table .count", function() {
			var day = $(this).closest(".cell").data("day");
			$("#schedule-table th").removeClass("active");
			$("#schedule-table th[data-day=" + day + "]").addClass("active");
	
			$.ajax({
				url: "/" + I18n["meta"]["code"] + "/schedule/view_option",
				dataType: "script",
				data: {view_option: day }
			});
		});
		
		/*click on remove button of subject tag*/
		$("#schedule-table-wrapper").on("click", ".subject-remove", function() {
	  	//update query and page
			var query = $("#filter-schedule #search").val();
			var page = $("#schedule-sub-list ul").data("page");
			var day = $("#schedule-table th.active").data("day");
			
			$.ajax({
				url: $(this).attr("href"),
				dataType: "script",
				type: "DELETE",
				data: {search: query, page: page, view_option: day}
			});
			
			return false;
		});
		
		/*For live search*/
		var timeout; // add delay time
	
	  $("#filter-schedule input").keyup(function() {
			window.clearTimeout(timeout); //clear delay
	    timeout = window.setTimeout(function(){ //set a new delay, after an amount of time, ajax function will be called
			  $.ajax({
				  url: $("#filter-schedule").attr("action"),
				  data: $("#filter-schedule").serialize(), //default contenttype is url text
				  success: ajaxSuccess,
				  dataType: "script"
				});
			}, 500);
	
			return false;
	  });
	  
	});//end of ready function
});