var gbks = gbks || {};

gbks.jQueryPlugin = function() { 
  
  this.init = function() {
    $(window).resize($.proxy(this.resize, this));
    this.resize();
  };
  
  this.resize = function() {
  	alert("hello");
    $('#notes li').wookmark({
    	align: 'center',
  		autoResize: true,
      offset: 10,
      container: $('#container'),
    });
  };
  
}

var instance = null;
$(window).on('page:load', function(){
  instance = new gbks.jQueryPlugin();
  instance.init();
});