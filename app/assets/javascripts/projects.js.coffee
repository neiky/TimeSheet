# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery(document).ready ->
	$('document').tooltip
	#$("a[rel=tooltip]").tooltip
	
	$('#add_member_link').css("visibility", "visible")
	$('#add_member_button').css("visibility", "hidden")
	
	$('#add_member_link').click ->
	  if $('#member_email').val() != ""
	    $('#member_error').remove()
	    $("#ajax_loading_dialog").modal('show')
	    request = $.ajax url: "add_member", type: "POST", data: { email : $('#member_email').val() }, dataType: "script"
	    request.done( -> $("#ajax_loading_dialog").modal('hide'))
	    return false
	  else
	    return false

	return
