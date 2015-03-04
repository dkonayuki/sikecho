(function($) {
	$.fn.hovercard = function (options) {
		
		var settings = $.extend({
			//default values
			content: '',
			placement: 'bottom',
			durationIn: 500,
			durationOut: 500
		}, options);
		
		var content = settings.content;
		var durationIn = settings.durationIn;
		var durationOut = settings.durationOut;
		var placement = settings.placement;
		
		//add content to body
		content.detach();
		$("body").append(content);
		
		var timeout; // add delay time
		
		function hideContent() {
			window.clearTimeout(timeout); //clear delay
	    timeout = window.setTimeout(function() { //set a new delay
    		content.fadeTo(200, 0);
    		content.css("display", "none");
			}, durationOut);
		}

		$(this).mousemove(function(e) {
			window.clearTimeout(timeout); //clear delay
	    timeout = window.setTimeout(function() { //set a new delay
	    	
        // position of mouse
	      var pos = {
	        top: e.pageY,
	        left: e.pageX
	      };
	      
	      var pos_to_window = e.pageY - $(window).scrollTop();
	      
	      // position of content
	      switch (placement) {
			    case "top":
	      		pos.top -= content.outerHeight();
			      if (pos_to_window < content.outerHeight()) {
			      	pos.top += content.outerHeight();
			      }
		        break;
			    case "bottom":
			      if (($(window).height() - pos_to_window) < content.outerHeight()) {
			      	pos.top -= content.outerHeight();
			      }  
		        break;
				}

				// add px unit
				pos.top += 'px';
				pos.left += 'px';

	      if (content.css("display") == "none") {
      		content.css(pos).fadeTo(200, 100);
	      }
			}, durationIn);
			
		});
		
		$(this).mouseleave(hideContent);
		
		content.mousemove(function(e) {
			window.clearTimeout(timeout); //clear delay, cancel event fadeTo
		});
		
		content.mouseleave(hideContent);
		
    return $(this);
	};
}(jQuery));