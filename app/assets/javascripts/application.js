// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require twitter/bootstrap
//= require dataTables/jquery.dataTables
//= require_tree .
//
var winW = 630, winH = 460;
if (document.body && document.body.offsetWidth) {
	winW = document.body.offsetWidth;
	winH = document.body.offsetHeight;
}
if (document.compatMode=='CSS1Compat' &&
		document.documentElement &&
		document.documentElement.offsetWidth ) {
	winW = document.documentElement.offsetWidth;
	winH = document.documentElement.offsetHeight;
}
if (window.innerWidth && window.innerHeight) {
	winW = window.innerWidth;
	winH = window.innerHeight;
}

$.urlParam = function(name){
	var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);
	if (!results)
	{ 
		return 0; 
	}
	return results[1] || 0;
}

var tables = [];

$(document).ready(function() {
	if($.urlParam('t') != 0) {
		$('#tab-'+$.urlParam('t')).tab('show');
	}

	tables = ($('.datatableable').dataTable( {
		"bPaginate": false,
	       "bLengthChange": false,
	       "bFilter": true,
	       "bSort": true,
	       "bInfo": false,
	       "bAutoWidth": false,
	       "sScrollY": winH - 300,
	       "bScrollCollapse": true
	} ));

	$('a[data-toggle="tab"]').on('shown', function (e) {
		tables.map(function(i){
			i.fnDraw();
		});
	})

});

$.extend( $.fn.dataTableExt.oStdClasses, {
    "sSortAsc": "header headerSortDown",
    "sSortDesc": "header headerSortUp",
    "sSortable": "header"
} );
