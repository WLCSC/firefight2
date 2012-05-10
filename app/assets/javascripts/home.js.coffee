# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#


jQuery ->
	$('.datatableable').dataTable
		bPaginate: false
		bInfo: false
		sScrollY: winH - 300 
		sDom: "<'row'<'span8'l><'span8'f>r>t<'row'<'span8'i><'span8'p>>"

