var Telasi = {};

Telasi.search = function(options, callback) {
  var field  = $('#' + (options.field || 'search'));
  var result = $('#' + (options.field || 'result'));
  field.keyup(function() {
	var url      = options.url;
	var query    = field.val();
    var full_url =  url + '?q=' + query;
	$.get(full_url, function(data) {
      result.html(data);
    }, 'html');
  });
};