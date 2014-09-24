(function($) {
	$.fn.hovercard = function (options) {
		
		var settings = $.extend({
			//default values
			content: '',
			durationIn: 500,
			durationOut: 500
		}, options);
		
		var content = settings.content;
		var durationIn = settings.durationIn;
		var durationOut = settings.durationOut;
		
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
	      var pos = {
	        // position of mouse
	        top: (e.pageY) + 'px',
	        left: (e.pageX) + 'px'
	      };

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