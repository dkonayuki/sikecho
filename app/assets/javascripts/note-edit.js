$(document).on("page:change", function() {
	$(".notes.edit, .notes.new").ready(function() {
	
		$("#edit-note-area").wysihtml5({locale: "en-US"});
		$('.selectpicker').selectpicker();
	
		// instantiate the bloodhound suggestion engine
		var tags = new Bloodhound({
		  datumTokenizer: function(d) { return Bloodhound.tokenizers.whitespace(d.name); },
		  queryTokenizer: Bloodhound.tokenizers.whitespace,
		  limit: 5,
		  prefetch: {
		  	ttl: 0,
		    url: '/tags.json',
		    filter: function(list) {
		      return $.map(list, function(tag) { return { name: tag.name }; });
		    }
		  }
		});
		 
		// initialize the bloodhound suggestion engine
		tags.initialize();
		
		//initiate tagsinput	
		$('.tag-input').tagsinput({
			tagClass: function(item) {
		    switch (item) {
		      case '試験対策': return 'label label-warning';
		      case '過去問題': return 'label label-success';
		      default: return 'label label-info';
		    }
	  	},
			confirmKeys: [13, 9]
		});
	
		$('.tag-input').tagsinput('input').typeahead(null, {
			// instantiate the typeahead UI
			  displayKey: 'name',
	 			source: tags.ttAdapter()
		}).bind('typeahead:selected', $.proxy(function (obj, datum) {  
		  this.tagsinput('add', datum.value);
		  //this.tagsinput('input').typeahead('val','');
		}, $('.tag-input')));
		
		//menu bar
		$('#add-all').on('click', function() {
			for (var i=1;i<=15;i++)
			{ 
				$('.tag-input').tagsinput('add', i + '回目' );
			}
		});
		$('.tag-menu-btn').on('click', function() {
			$('.tag-input').tagsinput('add', this.innerHTML );
		});
		$('#remove-all').on('click', function() {
			$('.tag-input').tagsinput('removeAll');
		});
		
		//fix for left over text
		$('.bootstrap-tagsinput input').blur(function() {
			$(this).val('');
		});
		
		//add old tags if exist
		/*getJSON is equivalent to 
		$.ajax({
		  dataType: "json",
		  url: url,
		  data: data,
		  success: success
		});*/
		// url in ajax syntax: "/tags.json" for absolute url. "tags.json" for relative url.
		$.getJSON("tags.json", function(data) {
			$.each(data, function(key, val) {
				$(".tag-input").tagsinput("add", val);
			});
		});

	});//end of ready function
});