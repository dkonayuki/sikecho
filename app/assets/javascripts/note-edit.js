$(document).on("page:load ready", function() {
	$(".notes.edit, .notes.new, .notes.create, .notes.update").ready(function() {

		$('.selectpicker').selectpicker();

		$("#edit-note-area").wysihtml5({locale: I18n["meta"]["code_country"]});
	
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
		      case I18n["notes"]["form"]["prepare_exam"]: return 'label label-warning';
		      case I18n["notes"]["form"]["past_exam"]: return 'label label-success';
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
			for (var i=1;i<=12;i++)
			{ 
				$('.tag-input').tagsinput('add', i);
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
		// however since rails using RESTFUL, update page has different url, so we need to specific the url
		if ($(".notes").hasClass("edit") || $(".notes").hasClass("update")) {
			$.getJSON("/notes/" + $("#note-edit").data("id") + "/tags.json", function(data, status) {
				$.each(data, function(key, val) {
					$(".tag-input").tagsinput("add", val);
				});
			});
		}

	});//end of ready function
});